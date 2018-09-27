import numpy as np
import matplotlib.pyplot as plt

#np.random.seed(0)

learning_rate = .1

def create_layer(num_inputs, num_outputs, num_nn_inputs):
   weights = np.zeros(shape = (num_outputs, num_inputs))
   biases = np.zeros(shape = (num_outputs, 1))
   for row in range(0, weights.shape[0]):
      for col in range(0, weights.shape[1]):
         weights[row][col] = np.random.uniform(low = -1/np.sqrt(num_nn_inputs), high = 1/np.sqrt(num_nn_inputs))

   return weights, biases

def fwd_prop_layer(layer, vector):
   weights = layer[0]
   biases = layer[1]
   return np.add(np.matmul(weights, vector), biases)

def fwd_prop_layer_relu(layer, vector):
   weights = layer[0]
   biases = layer[1]
   result = np.add(np.matmul(weights, vector), biases)
   for row in range(0, result.shape[0]):
      if result[row][0] < 0:
         result[row][0] = 0
   return result

def get_cost(result, answer):
   l = len(result)
   cost = 0
   for i in range(0, l):
      cost = cost +  (result[i][0] - answer[i][0]) ** 2
   return cost


def get_gradient(layer, activation, del_c_del_a):
   result = fwd_prop_layer(layer, activation)

   weight_grad = np.zeros(shape = layer[0].shape)
   biases_grad = np.zeros(shape = layer[1].shape)
   for row in range(0, weight_grad.shape[0]):
      for col in range(0, weight_grad.shape[1]):
            weight_grad[row][col] += activation[col][0] * 1 * del_c_del_a[row][0]

   for row in range(0, biases_grad.shape[0]):
      biases_grad[row][0] += del_c_del_a[row]
   del_c_del_a2 = np.zeros(shape = (len(weight_grad[0]), 1))
   for row in range(0, weight_grad.shape[0]):
      for col in range(0, weight_grad.shape[1]):
         del_c_del_a2[col][0] += layer[0][row][col] * del_c_del_a[row][0]



   return (-learning_rate * weight_grad, -learning_rate * biases_grad, del_c_del_a2)

def get_gradient_test(layer, activation, answer):
   ep = 1e-8
   result = fwd_prop_layer(layer, activation)
   c1 = get_cost(result, answer)

   weight_grad = np.zeros(shape = layer[0].shape)
   biases_grad = np.zeros(shape = layer[1].shape)


   for row in range(0, weight_grad.shape[0]):
      for col in range(0, weight_grad.shape[1]):
         layer[0][row][col] = layer[0][row][col] + ep
         test_result = fwd_prop_layer(layer, activation)
         c2 = get_cost(test_result, answer)
         weight_grad[row][col] = (c2 - c1) / ep
         layer[0][row][col] = layer[0][row][col] - ep

   for row in range(0, biases_grad.shape[0]):
      layer[1][row][0] = layer[1][row][0] + ep
      test_result = fwd_prop_layer(layer, activation)
      c2 = get_cost(test_result, answer)
      biases_grad[row][0] = (c2 - c1) / ep
      layer[1][row][0] = layer[1][row][0] - ep

   del_c_del_a2 = np.zeros(shape = (len(weight_grad[0]), 1))

   for row in range(0, len(activation)):
      activation[row][0] = activation[row][0] + ep
      test_result = fwd_prop_layer(layer, activation)
      c2 = get_cost(test_result, answer)
      del_c_del_a2[row][0] = (c2 - c1) / ep
      activation[row][0] = activation[row][0] - ep

   return (-learning_rate * weight_grad, -learning_rate * biases_grad, del_c_del_a2)


def update_layer(layer, grad):
   return np.add(layer[0], grad[0]), np.add(layer[1], grad[1])


def get_del_c_del_a(result, answer):
   return (2 * np.subtract(result, answer))
#TESTING GET_GRADIENT WORKS

#new_layer = create_layer(5, 3, 5)
#print("starting", new_layer[0])
#act = [[1], [5], [1], [6], [1]]
#ans = [[0], [0], [0]]
#delcdela = get_del_c_del_a(fwd_prop_layer(new_layer, act), ans)
#calc = get_gradient(new_layer, act, delcdela)
#print("calc", calc)
#print("----------------")
#test= get_gradient_test(new_layer, act, ans)
#print("test", test)
#print("---------------difference------------------")
#
#print("weight difference", np.subtract(calc[0], test[0]))
#print("bias difference", np.subtract(calc[1], test[1]))
#print("activaion difference", np.subtract(calc[2], test[2]))

#TESTING IN COMPARISON WITH OCAML
def test_layer(num_inputs, num_outputs):
   weights = np.zeros(shape = (num_outputs, num_inputs))
   biases = np.zeros(shape = (num_outputs, 1))
   iter = 0
   for row in range(0, weights.shape[0]):
      for col in range(0, weights.shape[1]):
         weights[row][col] = iter
         iter += 1
   return weights, biases

new_layer = test_layer(5,5)
act = [[0.],[1.],[2.],[3.],[4.]]
exp = [[4.],[3.],[2.],[1.],[0.]]
delcdela = get_del_c_del_a(fwd_prop_layer(new_layer, act), exp)
calc = get_gradient(new_layer, act, delcdela)
print("calc", calc)
print("----------------")
test= get_gradient_test(new_layer, act, exp)
print("test", test)
print("---------------difference------------------")

print("weight difference", np.subtract(calc[0], test[0]))
print("bias difference", np.subtract(calc[1], test[1]))
print("activaion difference", np.subtract(calc[2], test[2]))

#new_layer = create_layer(5, 3, 5)
#print(fwd_prop_layer_relu(new_layer, [[1], [1], [1], [1], [1]]))
#grads = get_gradient(new_layer, [[1], [1], [1], [1], [1]], [[0], [0], [0]])
#layer = (np.add(new_layer[0], grads[0]), np.add(new_layer[1], grads[1]))
#print(fwd_prop_layer_relu(layer, [[1], [1], [1], [1], [1]]))

#TESTING NOT
#
#
#def test_layer(layer):
#   correct = 0
#   for i0 in range(0, 2):
#         for i1 in range(0, 2):
#            for i2 in range(0, 2):
#               for i3 in range(0, 2):
#                  for i4 in range(0, 2):
#                     vector = [[i0], [i1], [i2], [i3], [i4]]
#                     answer = [[int(0 == i0)], [int(0 == i1)], [int(0 == i2)], [int(0 == i3)], [int(0 == i4)]]
#                     result = fwd_prop_layer(layer, vector)
#                     for x in range(0, 5):
#                        if result[x][0] > .5:
#                           result[x][0] = 1
#                        else:
#                           result[x][0] = 0
#
#                     if np.array_equal(result, answer):
#                        correct = correct + 1
#   return correct/32
#
#layer = create_layer(5, 5, 5)
#progress = []
#for epoch in range(0, 50):
#   weight_grad = np.zeros(shape = layer[0].shape)
#   biases_grad = np.zeros(shape = layer[1].shape)
#   gs = (weight_grad, biases_grad)
#   for example in range(0, 100):
#      answer = [[0], [0], [0], [0], [0]]
#      vector = [[np.random.uniform()],\
#                 [np.random.uniform()],\
#                 [np.random.uniform()],\
#                 [np.random.uniform()],\
#                 [np.random.uniform()]]
#      for i in range(0, 5):
#         if vector[i][0] > 0.5:
#            vector[i][0] = 1
#            answer[i][0] = 0
#         else:
#            vector[i][0] = 0
#            answer[i][0] = 1
#      temp_gs = get_gradient(layer, vector, answer)
#      gs = (np.add(temp_gs[0], gs[0]), np.add(temp_gs[1], gs[1]))
#
#   progress.append(test_layer(layer))
#   gs = gs[0] * (1 / 100), gs[1] * (1 / 30)
#
#   layer = update_layer(layer, gs)
#
#xs = range(0, len(progress))
#plt.plot(xs, progress)
