ActiveRecord::Schema.define :version => 0 do
  create_table "advertises", :force => true do |t|
    t.string :name
    t.string :lastname
  end
end