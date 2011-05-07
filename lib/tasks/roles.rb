[ 'suttree' ].each do |login|
  u = User.find_by_login(login)
  u.has_role 'admin'
  u.save!
end