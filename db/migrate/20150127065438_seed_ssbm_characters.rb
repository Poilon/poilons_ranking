class SeedSsbmCharacters < ActiveRecord::Migration
  def change
    [
      'Bowser', 'Captain Falcon', 'Donkey Kong', 'Dr Mario', 'Falco', 'Fox', 'Ganondorf',
      'Ice Climbers', 'Jigglypuff', 'Kirby', 'Link', 'Luigi', 'Mario', 'Marth', 'Mewtwo',
      'Mr Game&Watch', 'Ness', 'Peach', 'Pichu', 'Pikachu', 'Roy', 'Samus', 'Sheik', 'Yoshi',
      'Young Link', 'Zelda'
    ].each do |name|
      Character.create(game_id: 1, name: name, slug: name.parameterize.underscore)
    end
  end
end
