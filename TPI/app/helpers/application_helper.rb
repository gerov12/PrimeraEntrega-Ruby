module ApplicationHelper
    def error_message(model, field)
        error = model.errors[field].first
        if !error.nil?
            return error
        end
    end
end
