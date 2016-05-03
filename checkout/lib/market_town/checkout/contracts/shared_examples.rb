shared_examples_for 'a command method' do
  it { is_expected.to be_nil }
end

shared_examples_for 'a query method' do
  it { is_expected.to be_a Hash }
end

shared_examples_for 'a boolean query method' do
  it { is_expected.to match(true).or(match(false)) }
end
