import json

antimony_file = "beam_chain_single.sb"

all_nodes = []


class MyClass:
  """Learning classes in python"""
  i = 44;
  parameters = []

  def __init__(self):
    self.i = 55;





with open(antimony_file, "r+") as json_file:

  json_data = json.load(json_file)

  nodes = json_data['nodes']

  num_nodes = len(nodes)

  for i in range(0, len(nodes)):
    child = nodes[i]

    uid = child['uid']
    datums = child['datums']
    name = child['name']
    inspector = child['inspector']
    script = child['script']

    print "----------"
    print "node #%d" % i
    print "name = %s" % name
    print "uid = %s" % uid
    print "num datums = %d" % len(datums)

    for j in range(0, len(datums)):
      data = datums[j]
      data_uid = data['uid']
      data_name = data['name']
      data_expr = data['expr']
      data_type = data['type']
      print "    %s (%s) expr = %s uid = %s" % (data_name, data_type, data_expr, data_uid)

    print "inspector node position = (%.2f, %.2f)" % (inspector[0], inspector[1])
    print "num lines in script = %d" % len(script)

  x = MyClass()
  print x.i

  x.parameters.append( {"name": "x", "val": -3.4} )
  x.parameters.append( {"name": "y", "val": -1.27} )
  print len(x.parameters)

  all_nodes.append( {"name": "cool name", "obj": x} )
  print all_nodes[0]['name']
  print all_nodes[0]['obj'].i








