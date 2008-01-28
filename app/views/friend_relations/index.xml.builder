xml.friendlist do
	for f in @friendsList
		xml.friend do
			xml.id(f.id)
			xml.nickname(f.nickname)
		end
	end
end