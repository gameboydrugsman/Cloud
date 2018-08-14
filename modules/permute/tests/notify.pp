permute { "Colors":
  resource  => "notify",
  unique    => {
    message => ["red", "blue", "green"]
  },
  common => {
    tag  => 'bikesheds',
  },
}
