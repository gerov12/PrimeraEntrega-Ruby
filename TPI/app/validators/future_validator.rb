class FutureValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless value > DateTime.now
            record.errors.add attribute, (options[:message] || 'must be in the future')
        end
    end
end