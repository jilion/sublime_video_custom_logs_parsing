ignore /upload/

guard :rspec, bundler: false do
  watch(%r{^spec/.+/.+_spec\.rb})
  watch(%r{^app/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }
end
