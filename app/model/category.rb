module Model
  #
  # It represents a product category
  #
  class Category
     include DataMapper::Resource
     storage_names[:default] = 'categories'

     property :id, Serial
     property :code, String, length: 20, required: true
     property :name, String, length: 255, required: true

  end
end
