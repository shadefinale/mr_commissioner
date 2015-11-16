VCR.configure do |c|
  #where casssetes will be saved
  c.cassette_library_dir = "spec/vcr"
  # HTTP request service
  c.hook_into :mechanize
end
