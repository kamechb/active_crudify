module ActiveCrudify
  module ClassMethods
    # === Parameters
    # * model_name
    #   Specify the model name like :post, :blog
    # * options
    #
    # === Options
    # [:class_name]
    #   Specify the class name for model.
    # [:plural_name]
    # [:order_by]
    # [:conditions]
    #   Specify the condition which will be used in where clauses. 
    # [:namespace]
    #   Specify the controller in which namespace, like admin. 
    # [:only]
    #   Actions will be defined for controller.
    # [:except]
    #   Define the actions exclude this option specified.
    def crudify(model_name, options = {})
      self.responder = ActiveCrudify::Responder
      respond_to :html, :json, :xml

      options = ActiveCrudify.default_options(model_name).merge(options)

      allowed_actions = [:index, :new, :create, :show, :edit, :update, :destroy]
      if options[:only]
        allowed_actions = options[:only] 
      elsif options[:except]
        allowed_actions = allowed_actions - options[:except]
      end

      singular_name = options[:singular_name]
      plural_name   = options[:plural_name]
      class_name    = options[:class_name]
      klass         = class_name.constantize
      namespace     = options[:namespace]
      responded     = namespace ? [namespace] : []
      

      options[:paginate] = options[:paginate] && klass.respond_to?(:page)

      module_eval %(
        protected

        def set_crud_options
          @crud_options ||= #{options.inspect}
        end

        def what
          @what ||= '#{options[:title]}'
        end

        def find_#{singular_name}
          set_instance(#{class_name}.find(params[:id]))
        end

        def paginate_all_#{plural_name}
          set_collection(#{class_name}.page(params[:page]).order(@crud_options[:order_by]).where(conditions))
        end

        def find_all_#{plural_name}
          set_collection(#{class_name}.order(@crud_options[:order_by]).where(conditions))
        end

        def conditions
          @conditions ||= @crud_options[:conditions]
        end

        def set_instance(record)
          @instance = @#{singular_name} = record
        end

        def set_collection(records)
          @collection = @#{plural_name} = records
        end
      )

      module_eval %(

        before_filter :find_#{singular_name},
                      :only => [:update, :destroy, :edit, :show]

        before_filter :set_crud_options

        

        if #{allowed_actions.include?(:new)}
          def new
            @#{singular_name} = #{class_name}.new
          end
        end

        if #{allowed_actions.include?(:show)}
          def show
            respond_with(@#{singular_name})
          end
        end

        
        if #{allowed_actions.include?(:create)}
          def create
            @instance = @#{singular_name} = #{class_name}.new(params[:#{singular_name}])
            return if before_create === false
            @instance.save
            respond_with(#{namespace.inspect}, @#{singular_name})
          end
        end

        if #{allowed_actions.include?(:edit)}
          def edit

          end
        end

        if #{allowed_actions.include?(:update)}
          def update
            return if before_update === false
            @#{singular_name}.update_attributes(params[:#{singular_name}])
            respond_with(#{namespace.inspect}, @#{singular_name})
          end
        end

        if #{allowed_actions.include?(:destroy)}
          def destroy
            return if before_destroy === false
            @#{singular_name}.destroy
            respond_to do |f|
              f.html { redirect_to([#{namespace.inspect}, :#{plural_name}]) }
              f.any(:xml, :json) {head :ok}
            end
          end
        end
      )


      if allowed_actions.include?(:index)
        if options[:paginate]
          module_eval %(
            def index
              paginate_all_#{plural_name}
              respond_with(#{responded} << @#{plural_name})
            end
          )
        else
          module_eval %(
            def index
              find_all_#{plural_name}
              respond_with(#{responded} << @#{plural_name})
            end
          )
        end
      end

    end

  end
end
