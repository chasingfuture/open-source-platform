require 'rails_helper'

# Activerecord translations are not exactly the same between french and english
# Some keys are more detailed (zero, one, other for example)
# So we skip them here to avoid issues
#
# This array should only contain default activerecord keys here
# Even thought it is not optimal, we mostly care about user-defined keys
KEYS_TO_DISMISS = %w[
  datetime.distance_in_words
  errors.template
  flash
  number.human.storage_units.units
]

def build_keys(value, current_path = nil)
  keys = []

  value.each do |k, v|
    path = current_path.blank? ? k.to_s : "#{current_path}.#{k.to_s}"

    next if KEYS_TO_DISMISS.include? path

    keys << path
    keys += build_keys(v, path) if v.is_a?(Hash)
  end

  keys
end

def fetch_keys(locale)
  I18n.enforce_available_locales!(locale)
  build_keys I18n.backend.send(:translations)[locale]
end

RSpec.feature "Translations" do

  describe 'check every translations are provided' do

    let(:fr_keys) { fetch_keys(:fr) }
    let(:en_keys) { fetch_keys(:en) }

    it 'should not be different keys' do
      expect(fr_keys).to match_array en_keys
    end

  end

end
