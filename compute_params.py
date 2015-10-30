import json

antimony_file = "beam_chain_single.sb"

all_nodes = []


class Node:
  """Each node in the Antimony file"""
  uid = 0
  name = ""
  parameters = []

  #def __init__(self):
    

with open(antimony_file, "r+") as json_file:

  json_data = json.load(json_file)

  nodes = json_data['nodes']

  num_nodes = len(nodes)

  for i in range(0, len(nodes)):

    n = Node()

    child = nodes[i]

    uid = child['uid']
    datums = child['datums']
    name = child['name']
    inspector = child['inspector']
    script = child['script']

    n.uid = uid;
    n.name = name;

    print "----------"
    print "node #%d" % i
    print "name = %s" % name
    print "uid = %s" % uid
    print "num datums = %d" % len(datums)

    for j in range(0, len(datums)):

      data = datums[j]
      # add these ^ to the parameters

      data_uid = data['uid']
      data_name = data['name']
      data_expr = data['expr']
      data_type = data['type']

      n.parameters.append( {"name": data_name, "val": data_expr} )

      print "    %s (%s) expr = %s uid = %s" % (data_name, data_type, data_expr, data_uid)

    print "inspector node position = (%.2f, %.2f)" % (inspector[0], inspector[1])
    print "num lines in script = %d" % len(script)

    all_nodes.append( {"name": name, "obj": n} )

  print "first node: %s, uid = %s parameters #0 name: %s" % (all_nodes[0]['name'], all_nodes[0]['obj'].uid, all_nodes[0]['obj'].parameters[0]['name'] )



  # x = MyClass()
  # print x.i

  # x.parameters.append( {"name": "x", "val": -3.4} )
  # x.parameters.append( {"name": "y", "val": -1.27} )
  # print len(x.parameters)

  # all_nodes.append( {"name": "cool name", "obj": x} )
  # print all_nodes[0]['name']
  # print all_nodes[0]['obj'].i






