class ShiftValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        hours = ['8','9','10','11','12','13','14','15','16']
        mins = ['0','15','30','45']
        unless value.to_datetime.hour.to_s.in?(hours) && value.to_datetime.min.to_s.in?(mins)
            record.errors.add attribute, (options[:message] || 'must be a valid shift schedule')
        end
    end
end