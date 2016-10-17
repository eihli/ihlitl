# Fingerprint < - > Unique Id Example Contract

Imagine there is an API which returns a unique identifier when given a fingerprint.

The same API can create a unique identifier when given a fingerprint if the fingerprint does not already exist.

Imagine the converse API which returns a fingerprint when given a unique identifier and which can create a fingerprint when given a unique identifier if the unique identifier does not already exist

Imagine we have some payload which contains either a fingerprint or a unique identifier. We don't know which.

We want to get a fingerprint and if it doesn't exist, create it.

## Solution

Create a FingerprintContract which is guaranteed to resolve to a fingerprint.

This is a simple example for demonstration, but imagine a complicated web of API calls needed to accomplish a specific result: one where you can't make your last API call until you've a certain two others, and where one of those others may or may not require a third depending on the result.

With this architecture, we don't have to explicitly handle each condition. We can specify which contract we want to resolve, give it any initial payload, and it will make its best effort to resolve itself based on its clauses and sub contracts.

### FingerprintContract

One clause

- Fingerprint exists on payload

Two or conditional sub contracts

- FingerprintGetContract
- FingerprintCreateContract

### FingerprintGetContract


One sub contract (We cannot get a fingerprint if we don't have a unique id)

- UniqueIDContract

Two clauses

- It has made a get request to the fingerprint url and got a 200 response
- Fingerprint exists on payload

One fulfillment agent

- Makes a get request to the fingerprint API
- Updates payload with response if successful

### FingerprintCreateContract

One sub contract (Again, cannot create fingerprint if we don't have a unique id)

- UniqueIDContract

Two clauses

- It has made a post request to the fingerprint url and got a 201 response
- Fingerprint exists on payload

One fulfillment agent

- Makes a post request to the fingerprint API
- Updates payload with response if successful


### UniqueIDContract

One clause

- Unique ID exists on payload

Two sub contracts

- UniqueIDGetContract
- UniqueIDCreateContract

### UniqueIDGetContract

One sub contract (Cannot create a unique id if we don't have a fingerprint)

- FingerprintContract

Two clauses

- Made a get request to the unique id API and got a 200 response
- Unique id exists on payload

### UniqueIDCreateContract

One sub contract (...)

- FingerprintContract

Two clauses

- Made a post request to the unique id API and got a 201 response
- Unique id exists on payload
