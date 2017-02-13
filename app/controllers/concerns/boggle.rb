class Boggle

  URI_SYS = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=" + Rails.application.secrets.api_key + "&input="

  class << self
    def generate_grid(grid_size)
      # TODO: generate random grid of letters
      grid = []
      alphabet = ("A".."Z").to_a
      grid_size.times do
        grid << alphabet[rand(26)]
      end
      grid
    end

    def run_game(attempt, grid, start_time, end_time)
      # TODO: runs the game and return detailed hash of result
      if attempt_valid?(attempt, grid)
        if english_word?(attempt)
          return well_done(attempt, (end_time - start_time).to_f)
        else
          return not_english_word
        end
      else
        return not_in_grid
      end
    end

    private

    def frequency(a_string)
      # initialise a hash with the frequency at 0 for all new keys
      letters_frequency = Hash.new(0)

      # compute the frequency for all letters of the word and store them in a hash
      a_string.chars.each { |letter| letters_frequency[letter] += 1 }

      letters_frequency
    end

    def attempt_valid?(attempt, grid)
      grid_frequency = frequency(grid.join(''))
      frequency(attempt.upcase).each do |letter, frequency|
        return false if frequency > grid_frequency[letter]
      end
      true
    end

    def translate_word(attempt)
      url = URI_SYS + attempt
      translation_response = open(url).read
      translation = JSON.parse(translation_response)
      translation["outputs"][0]["output"]
    end

    def english_word?(attempt)
      words = File.read('/usr/share/dict/words').upcase.split("\n")
      words.include?(attempt.upcase) ? (return true) : (return false)
    end

    def well_done(attempt, time)
      {
        score: attempt.size * (60 - time),
        translation: translate_word(attempt),
        message: 'well done',
        time: time
      }
    end

    def not_english_word
      {
        score: 0,
        message: "not an english word"
      }
    end

    def not_in_grid
      {
        score: 0,
        message: "not in the grid"
      }
    end


  end
end
