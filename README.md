# IhliTL

API to API ETL

## Current State (Oct 13th)

- PipelineManager is instantiated with transforms
  - Transforms look like:
  - `[[TransformClass, arg1, arg2], [OtherTransformClass, arg1]]`
  - First transform typically a Source
  - Last transform must be a Destination
- PipelineManager calls run on the first transform
  - This kicks off the chain. Each transform is responsible for calling run on the next
- Sources, Transforms, and Destinations all have similar APIs
  - They are initialized with a destination (except Destinations)
  - They have a run method which takes a payload
  - They have a deliver method which delivers their payload
    - Source and Transform delivers call deliver on the destination they were instantiated with.
    - Destination delivers go outside of the Pipeline

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
