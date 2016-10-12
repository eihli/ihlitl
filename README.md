# IhliTL

API to API ETL

## Ideas

- Shareable contracts
  - If one transform shares an inbound contract with another transforms outbound contract, they can be connected
- BaseTransform parent class for superclass error handling
- PipelineManager to specify which transforms can be run in parrallel and handle other administrative duties
- Payload passed from source through transforms to destination is serializable
  - If an API gem requires objects, build them in Destination

## Scratchpad

```
SomePipelineManager.load(SomeSource)
  .delivers_to_async(SomeSerialTransform).with(SomeContract)
  .delivers_to(SomeTransform).with(SomeContract)
  .delivers_to(SomeOtherTransform).with(SomeOtherContract)
  .delivers_to(SomeDestination).with(SomeDestinationContract)
```
