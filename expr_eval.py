
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

