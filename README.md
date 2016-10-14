# IhliTL

API to API ETL

## Current State (Oct 13th)

### Pipeline Managers

- PipelineManager is instantiated with transforms
  - Transforms look like:
  - `[[TransformClass, arg1, arg2], [OtherTransformClass, arg1]]`
  - First transform typically a Source
  - Last transform must be a Destination
- On `initialize`
  - Instantiates each transform with args
  - This is where args would be pulled from external sources like ENV variables or DB calls
- On `run`
  - Calls run on first transform
  - This kicks off the chain
  - Each transform will call run on the next transform in the list, passing in its modified `payload`

### Sources and Transforms

- Sources and transforms have similar APIs
  - Initialized with another transform to which they send their modified payload
  - Must define private method `transform` which takes a payload, modifies it (optional), and returns it
  - Public method `run` takes a payload, transforms it, and delivers the result to the next transform

### Destinations

- Initialized with any optional args required to send the payload to its final destination
- Must define private method `deliver` which takes a payload and sends it to some external system
- Public method `run` to match with Transform API so Destination can be in list of Transforms passed to PipelineManager
  - TODO: Sources, Transforms, and Destinations all inherit from BaseTransform?

## See an Example

- `/examples/nfl.rb`
- Defines several transforms
- Defines a Destination which just puts payload to console
- Instantiates a pipeline manager and calls run
- Run it and see it in action with `ruby example/nfl.rb`

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

```
class PipelineManager
pipeline = [
[NFLTransform, credentials, args],
[WeatherTransform, api_key, other_args],
[StockPriceTransform, credentials]
]

payload = {
initial_key: 'initial_values'
}

destination = ConsoleDestination

def run
# For each pipeline
  # Call run on the transform with args and payload
end

end
```
