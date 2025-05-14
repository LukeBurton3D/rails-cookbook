# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'json'
require 'open-uri'

puts 'Cleaning db...'
Recipe.destroy_all
Category.destroy_all
Bookmark.destroy_all

puts "Creating recipes..."
def recipe_builder(id)
  url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{id}"

  meal_serialized = URI.parse(url).read
  meal = JSON.parse(meal_serialized)["meals"][0]
  Recipe.create!(
    name: meal["strMeal"],
    description: meal["strInstructions"],
    image_url: meal["strMealThumb"],
    rating: rand(2..5.0).round(1)
  )
end

categories = ["Breakfast", "Pasta", "Seafood", "Dessert"]

categories.each do |category|
  url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=#{category}"
  recipe_list = URI.parse(url).read
  recipes = JSON.parse(recipe_list)
  recipes["meals"].each do |recipe|
    recipe_builder(recipe["idMeal"])
  end
end

puts "Created #{Recipe.count} recipes"

# puts "Creating recipes..."
# Recipe.create!(name: "Cheese Omelette", description: "Rustle up a simple omelette for a quick and easy snack any time of day. Use mature cheddar for maximum cheesy flavour", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2024/01/Cheese-omelette-45155e3.jpg?quality=90&webp=true&resize=600,545", rating: 4.1)
# Recipe.create!(name: "Creamy chicken pasta", description: "crowd-pleasing creamy chicken pasta for your next family meal. It's packed with flavour and is easy for anyone to make, including children", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2022/01/creamy-chicken-pasta-086c722.jpg?quality=90&webp=true&resize=600,545", rating: 3.6)
# Recipe.create!(name: "Fish tacos", description: "Pack in the flavour and lots of veg in this easy fish tacos recipe. It's an easy way to get your family eating more fish, and one portion counts as three of their 5-a-day", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2022/08/Fish-Tacos-1337495.jpg?quality=90&webp=true&resize=600,545", rating: 2.9)
# Recipe.create!(name: "Falafel burgers", description: "A healthy burger that's filling too. These are great for anyone after a satisfying bite low in calories.", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2010/06/Easy-falafels-786beb5.jpg?quality=90&webp=true&resize=600,545", rating: 4.4)
# Recipe.create!(name: "Mushroom & potato curry", description: "Create a tasty, spicy vegetarian dish with mushroom and curry in less than half an hour", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/recipe-image-legacy-id-339051_11-3366b35.jpg?quality=90&webp=true&resize=440,400", rating: 4.4)
# Recipe.create!(name: "Thai prawn noodles", description: "Ready in 30 minutes, this stir-fried prawn, egg and noodle dish is perfect for a midweek meal", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/thai-prawn-noodles-ba40e71.jpg?quality=90&webp=true&resize=440,400", rating: 2.9)
# Recipe.create!(name: "Sausage, leek & fennel pasta", description: "This quick and easy pasta dish is sure to be a family favourite and it's ready in 30 minutes", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/sausage-leek-fennel-pasta-d7dcbf8.jpg?quality=90&webp=true&resize=440,400", rating: 1.8)
# Recipe.create!(name: "Salmon risotto", description: "Creamy rice and tender salmon make a comforting dinner. Stir through lemon juice and parmesan before serving this easy, delicious meal that's full of omega 3 and high in protein", image_url: "https://images.immediate.co.uk/production/volatile/sites/30/2023/03/Salmon-risotto-ae398a0.jpg?quality=90&webp=true&resize=600,545", rating: 4.7)

# puts "Created #{Recipe.count} recipes"
