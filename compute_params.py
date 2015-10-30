import json

antimony_file = "beam_chain_single.sb"

all_nodes = []


class Node:
  """Each node in the Antimony file"""
  #uid = 0
  #name = ""
  #props = []

  def __init__(self):
    self.uid = 0
    self.name = ""
    self.props = []


with open(antimony_file, "r+") as json_file:

  json_data = json.load(json_file)

  nodes = json_data['nodes']

  num_nodes = len(nodes)

  all_nodes = [Node() for i in range(0, num_nodes)]

  for i in range(0, len(nodes)):

    child = nodes[i]

    uid = child['uid']
    datums = child['datums']
    name = child['name']
    inspector = child['inspector']
    script = child['script']

    #n = Node()
    n = all_nodes[i]
    n.uid = uid;
    n.name = name;

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

      d = {"name": data_name, "val": data_expr}

      n.props.append( d )
      print "%d, %s" % (j, n.props[j])
      #print "    %s (%s) expr = %s uid = %s" % (data_name, data_type, data_expr, data_uid)


    print "inspector node position = (%.2f, %.2f)" % (inspector[0], inspector[1])
    print "num lines in script = %d" % len(script)
    print "num of props: %d" % (len(n.props))




  print "------"

  print "first node: %s, uid = %s, props #0 name: %s" % (all_nodes[0].name, all_nodes[0].uid, all_nodes[0].props[0]['name'] )
  print "2nd node: %s, uid = %s, props #0 name: %s" % (all_nodes[1].name, all_nodes[1].uid, all_nodes[1].props[0]['name'] )















