function img = load_chess(filename)

img = slurp(filename, 'c');
img = flipud(img);

end
