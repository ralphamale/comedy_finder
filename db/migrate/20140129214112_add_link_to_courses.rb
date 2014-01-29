class AddLinkToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :link, :string
  end
end
