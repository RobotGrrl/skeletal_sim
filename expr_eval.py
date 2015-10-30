import re


c1_x = -3.4
c1_y = -1.27
c0_len = 2.76

expr1 = "c1_x + c0_len"
res1 = eval(expr1)
print "1: %s" % (res1)

expr2 = "c1.x + c0.len"
new1 = expr2.replace("c1.x", "a")
new2 = new1.replace("c0.len", "b")
print "2: %s" % (new2)

expr3 = "c1.x + c0.len"
new1 = expr3.replace("c1.x", str(c1_x))
new2 = new1.replace("c0.len", str(c0_len))
print "3: %s" % (new2)

expr4 = new2
res1 = eval(expr4)
print "4: %s" % (res1)

print "-------"
print "5:"

#expr5 = "c1.x + c1.y"
expr5 = "c1.x+c1.y"
searchfor = "c1"
found_ind = 0
all_finds = []
for i in range(0, len(expr5)):
  res = expr5.find(searchfor, found_ind, len(expr5))
  if res == -1:
    break
  else:
    print "found %s at %d" % (searchfor, res)
    found_ind = res+1
    all_finds.append(found_ind)

split_str = expr5.split(searchfor)
for i in range(0, len(split_str)):
  # removing the .'s and +'s (basically anything not alpha numeric)
  # from the strings
  split_str[i] = re.sub('[^0-9a-zA-Z_-]+', '', split_str[i])

print split_str
