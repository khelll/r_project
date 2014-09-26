# This will guess the package versions class
FactoryGirl.define do
  factory :package_version do
    sequence(:version) { |n| "0.#{n}" }
    published_at Time.now
    sequence(:name) { |n| "Name of package #{n}" }
    sequence(:title) { |n| "Title of package #{n}" }
    sequence(:description) { |n| "Description of package #{n}" }
    authors 'someone <someone@testmail.com>'
    maintainers 'someone2 <someone2@testmail.com>'
  end

  factory :tmp_package_version, class: :package_version do
    version '1.1'
    published_at Time.now
    name 'ABCp2'
    title 'Approximate Bayesian Computational model for estimating P2'
    description 'This package tests the goodness of fit of a distribution of ' \
      'offspring to the Normal, Poisson, and Gamma distribution and ' \
      'estimates the proportional paternity of the second male (P2) based ' \
      'on the best fit distribution.'
    authors 'M. Catherine Duryea, Andrew D. Kern, Robert M. Cox, and Ryan '
    maintainers 'M. Catherine Duryea <duryea@dartmouth.edu>'
  end
end
