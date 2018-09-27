# -*- coding: utf-8 -*-
"""
Created on Wed Apr 25 17:20:45 2018

@author: wchlh
"""

import layer as ly
import numpy as np
import math
import sys

#number hidden layer >= 1
def create_nn(i_neur, h_neur, h_lay, o_neur):
   nn = []
   input_layer = ly.create_layer(i_neur, h_neur, i_neur)
   nn.append(input_layer)
   for i in range (0, h_lay - 1):
      nn.append(ly.create_layer(h_neur, h_neur, i_neur))
      
   nn.append(ly.create_layer(h_neur, o_neur, i_neur))
   
   return nn

#returns list of activations through layers
def fwd_prop(nn, vector):
   layers = len(nn)
   result = vector
   activations = [vector]
   for i in range(0, layers):
      result = ly.fwd_prop_layer(nn[i], result)
      activations.append(result)
   return activations


def get_cost(result, answer):
   l = len(result)
   cost = 0
   for i in range(0, l):
      cost = cost +  (result[i][0] - answer[i][0]) ** 2
   return cost

def get_gradient(nn, vector, answer):
   activations = fwd_prop(nn, vector)
   result = activations[-1]
   
   delc_dela = 2 * np.subtract(result, answer)
   
   updates_to_nn_rev = []
   
   for i in np.arange(len(nn) - 1, -1, -1):
      grads = ly.get_gradient(nn[i], activations[i], delc_dela)
      updates_to_nn_rev.append(grads)
      delc_dela = grads[2]
      
   updates_to_nn = updates_to_nn_rev[::-1]
   
   for i in range(0, len(updates_to_nn)):
      updates_to_nn[i] = (updates_to_nn[i][0], updates_to_nn[i][1])
      
   return updates_to_nn

def get_gradient_test(nn, vector, answer):
   activations = fwd_prop(nn, vector)
   result = activations[-1]
   
   c1 = get_cost(result, answer)
   
   updates_to_nn = []
   
   ep = 1e-4
   
   for layer in range(0, len(nn)):
      weight_grad = np.zeros(shape = nn[layer][0].shape)
      biases_grad = np.zeros(shape = nn[layer][1].shape)
      for row in range(0, weight_grad.shape[0]):
         for col in range(0, weight_grad.shape[1]):
            nn[layer][0][row][col] = nn[layer][0][row][col] + ep
            test_result = fwd_prop(nn, vector)[-1]
            c2 = get_cost(test_result, answer)
            weight_grad[row][col] = (c2 - c1) / ep
            nn[layer][0][row][col] = nn[layer][0][row][col] - ep
            
      for row in range(0, biases_grad.shape[0]):
         nn[layer][1][row][0] = nn[layer][1][row][0] + ep
         test_result = fwd_prop(nn, vector)[-1]
         c2 = get_cost(test_result, answer)
         biases_grad[row][0] = (c2 - c1) / ep
         nn[layer][1][row][0] = nn[layer][1][row][0] - ep
         
      updates_to_nn.append((-ly.learning_rate * weight_grad, -ly.learning_rate * biases_grad))
   
   return updates_to_nn

def add_nn(nn, grad):
   for i in range(0, len(nn)):
      nn[i] = np.add(nn[i][0], grad[i][0]), np.add(nn[i][1], grad[i][1])
   #print(nn)
   return nn

def scale_nn(nn, c):
   for i in range(0, len(nn)):
      nn[i] = nn[i][0] * c, nn[i][1] * c
   return nn

#standard_error_nn = create_nn(7, 10, 2, 7)
#
#grad_calc = get_gradient(standard_error_nn, [[1], [2], [3], [4], [5], [6], [7]], [[7], [6], [5], [4], [3], [2], [1]])
#grad_test = get_gradient_test(standard_error_nn, [[1], [2], [3], [4], [5], [6], [7]], [[7], [6], [5], [4], [3], [2], [1]])

#Testing reverse
#num_epoch = 100
#num_test = 100
#
#reverse_nn = create_nn(10, 12, 2, 10)
#for epoch in range(0, num_epoch):
#   print("epoch: ", epoch)
#   grad = []
#   for i in range(0, len(reverse_nn)):
#      grad.append((np.zeros(shape = reverse_nn[i][0].shape), np.zeros(shape = reverse_nn[i][1].shape)))
#      
#   for i in range(0, num_test):
#      vector = []
#      for j in range(0, 10):
#         vector.append([np.random.randint(0, 2)])
#      answer = vector[::-1]
#      temp_grad = get_gradient(reverse_nn, vector, answer)
#      grad = add_nn(temp_grad, grad)
#      
#   grad = scale_nn(grad, 1 / num_test)
#   reverse_nn = add_nn(reverse_nn, grad)



