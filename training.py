import nn
import numpy as np
import time
from mnist import MNIST

mndata = MNIST('sample')

images, labels = mndata.load_training()

#images are 28x28

num_epoch = 750
num_test = 80

og_start_time = time.clock()

digit_nn = nn.create_nn(784, 16, 2, 10)

for loop in range(0, 5):
   loop_start = time.clock()
   randomized_indexes = np.arange(0, 60000)
   np.random.shuffle(randomized_indexes)
   
   test_indexes = []
   
   for e in range(0, num_epoch):
      test_indexes.append(randomized_indexes[e * num_test:e*num_test + num_test])
      
   for epoch in range(0, num_epoch):
      start_time = time.clock()
      grad = []
      for i in range(0, len(digit_nn)):
         grad.append((np.zeros(shape = digit_nn[i][0].shape), np.zeros(shape = digit_nn[i][1].shape)))
      for i in range(0, num_test):
         index = test_indexes[epoch][i]
         vector = []
         img = images[index]
         for pixel in range(0, len(img)):
            vector.append([img[pixel] / 255])
         
         num = labels[index]
         answer = [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]]
         answer[num][0] = 1
         
         temp_grad = nn.get_gradient(digit_nn, vector, answer)
         grad = nn.add_nn(temp_grad, grad)
         
      grad = nn.scale_nn(grad, 1 / num_test)
      digit_nn = nn.add_nn(digit_nn, grad)
      time_took = time.clock() - start_time
      print("epoch:", epoch, "|", "time taken:", time_took, "s")
   print("loop:", epoch, "|", "time taken:", time.clock() - loop_start, "s")
print("total time taken:", time.clock() - og_start_time, "s")
   
test_images, test_labels = mndata.load_testing()
num_correct = 0
wrong_indexes = []
wrong_answer_vectors = []
wrong_answer = []
for image in range(0, len(test_images)):
   if (image % 100 == 0):
      print("test: ", image)
   vector = []
   for pixel in range(0, len(test_images[image])):
      vector.append([test_images[image][pixel] / 255])
      
   activations = nn.fwd_prop(digit_nn, vector)
   result = activations[-1]
   
   real_answer = test_labels[image]
   nn_answer = 0
   for j in range(0, len(result)):
      if result[j] > result[nn_answer]:
         nn_answer = j
   if nn_answer == real_answer:
      num_correct += 1
   else:
      wrong_indexes.append(image)
      wrong_answer_vectors.append(result)
      wrong_answer.append(nn_answer)
      
print("Number correct: ", num_correct, " out of 10,000")
print("Sucess rate: ", num_correct/10000)

def check_wrong():
   for i in range(0, len(wrong_indexes)):
       index = wrong_indexes[i]
       print("-----------image-------------")
       print(mndata.display(test_images[index]))
       print("-----------result vector-----")
       print(wrong_answer_vectors[i])
       print("-----------nn answer---------")
       print(wrong_answer[i])
       print("-----------real answer-------")
       print(test_labels[index])
       s = input('Next?')
       if len(s) > 4:
          break
   
