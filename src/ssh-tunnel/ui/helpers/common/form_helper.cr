module SSHTunnel
  module UI
    module Helpers
      module Common
        module FormHelper
          private def bind_submit_button
            button = Gtk::Button.cast(template_child("button.submit"))
            button.label = t("button.submit")

            button.clicked_signal.connect do
              submit_form form_object, params(scope: @form_scope)
            end
          end

          private def params(scope)
            params = Hash(Symbol, String).new
            form_fields.each do |field_name, opts|
              case opts[:type]
              when :text
                input = Gtk::Entry.cast(template_child("input.#{scope}.#{field_name}"))
                value = input.text
              when :int
                input = Gtk::Entry.cast(template_child("input.#{scope}.#{field_name}"))
                value = input.text
              when :select
                input = Gtk::ComboBoxText.cast(template_child("input.#{scope}.#{field_name}"))
                value = input.active_id
              else
                puts "Unknown type: #{field_name} => #{opts[:type]}"
              end
              params[field_name] = value.to_s
            end
            params
          end

          private def submit_form(form, params)
            form.submit(params)
            if form.valid?
              form.save
              save_and_reload_view
            else
              render_form_errors(scope: @form_scope, errors: form.errors)
            end
          end

          private def render_form_errors(scope, errors)
            form_fields.each do |field_name, _method|
              value = errors.has_key?(field_name) ? errors[field_name][0] : ""
              label = Gtk::Label.cast(template_child("error.#{scope}.#{field_name}"))
              label.text = value
            end
          end

          private def restore_form_values(scope, model)
            form_fields.each do |field_name, opts|
              restore_form_value(scope, model, field_name, opts)
            end
          end

          private def restore_form_value(scope, model, field_name, opts)
            # get model value
            value = model.fetch(field_name.to_s)

            case opts[:type]
            when :text
              input = Gtk::Entry.cast(template_child("input.#{scope}.#{field_name}"))
              input.text = value.nil? ? "" : value.as_s
            when :int
              input = Gtk::Entry.cast(template_child("input.#{scope}.#{field_name}"))
              input.text = value.nil? ? "" : value.as_i.to_s
            when :file
              input = Gtk::FileChooserWidget.cast(template_child("input.#{scope}.#{field_name}"))
            when :select
              input = Gtk::ComboBoxText.cast(template_child("input.#{scope}.#{field_name}"))
              if values = opts[:values]?
                values.each do |val|
                  input.append(val, t("form.tunnel.type_#{val}"))
                end
                input.active_id = value.nil? ? "" : value.as_s
              end
            else
              puts "Unknown type: #{field_name} => #{opts[:type]}"
            end
          end

          private def set_form_labels(scope, keys)
            keys.each do |key|
              label = Gtk::Label.cast(template_child("label.#{scope}.#{key}"))
              label.label = t("form.#{scope}.#{key}")
            end
          end
        end
      end
    end
  end
end
