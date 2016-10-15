module IhliTL
  class PipelineManager
    attr_accessor :transforms

    def initialize(transforms, payload)
      @payload = payload
      @transforms = instantiate_transforms(transforms)
    end

    def instantiate_transforms(transforms)
      # if we only have a single transform, it is a destination
      if transforms.length == 1
        transform_def = transforms[0]
        destination_class = transform_def[0]
        if transform_def.length > 1 # we have args
          args = transform_def[1..-1]
          return [destination_class.new(*args)]
        else
          return [destination_class.new]
        end
      else
        transform_def = transforms[0]
        destination_transforms = instantiate_transforms(transforms[1..-1])
        transform_class = transform_def[0]
        if transform_def.length > 1 # we have args
          args = transform_def[1..-1]
          transforms = [transform_class.new(destination_transforms[0], *args)]
            .concat(destination_transforms)
          return transforms
        else
          transforms = [transform_class.new(destination_transforms[0])]
            .concat(destination_transforms)
          return transforms
        end
      end
    end

  def run
    @transforms[0].run(@payload)
  end
end

