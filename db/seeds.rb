# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Faker::Superhero.unique.clear
3.times do
  name = Faker::Superhero.unique.name
  f = Foundation.create!(
    short_name: name[0..3].upcase,
    long_name: name
  )

  Faker::Company.unique.clear
  ot_ids = Array.new
  6.times do
    desc = Faker::Company.unique.industry
    ot = OrganizationType.create!(
      code: desc[0..2].upcase,
      description: desc,
      foundation_id: f.id
    )
    ot_ids << ot.id
  end

  Faker::Bank.unique.clear
  4.times do
    ba = BankAccount.create!(
      full_name: Faker::Bank.unique.name,
      primary: false,
      foundation_id: f.id,
      starting_balance: Faker::Number.between(from: 10, to: 10000) 
    )
  end

  fs_ids = Array.new
  2.times do
    name = Faker::Bank.unique.name
    fs = FundingSource.create!(
      code: name[0..3].upcase,
      short_name: name[0..8],
      full_name: name,
      foundation_id: f.id
    )
    fs_ids << fs.id
  end

  Faker::DcComics.unique.clear
  d_ids = Array.new
  8.times do
    name = Faker::DcComics.unique.hero
    d = Donor.create!(
      code: name[0..2].upcase,
      full_name: name,
      foundation_id: f.id
    )
    d_ids << d.id
  end

  Faker::Company.unique.clear
  50.times do
    Organization.create!(
      name: Faker::Company.unique.name,
      tax_number: Faker::Company.ein,
      contact: Faker::Name.name, 
      address_1: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip: Faker::Address.zip,
      foundation_id: f.id, 
      organization_type_id: ot_ids.sample
    )
    # 25.times do
    #   Contribution.create!(
    #     note: asd,
    #     donor_id: asd,
    #     funding_source_id: asd,
    #     organization_id: asd, 

    #   )
    # end
  end

end
