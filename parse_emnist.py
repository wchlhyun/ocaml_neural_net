import numpy as np
import time
# from mnist import MNIST
import tensorflow as tf
from PIL import Image
import os


from tensorflow.contrib.learn.python.learn.datasets.mnist import extract_images, extract_labels

with open('datasets/emnist/emnist-byclass-test-images.idx3-ubyte.gz', 'rb') as f:
   test_images = extract_images(f)
with open('datasets/emnist/emnist-byclass-test-labels.idx1-ubyte.gz', 'rb') as f:
   test_labels = extract_labels(f)

# with open('emnist-byclass-train-images.idx3-ubyte.gz', 'rb') as f:
#    train_images = extract_images(f)
# with open('emnist-byclass-train-labels.idx1-ubyte.gz', 'rb') as f:
#    train_labels = extract_labels(f)


num_char_dict = {}

for i in range(0, 62):
   if i < 10:
      num_char_dict[i] = str(i)
   elif i < 36:
      num_char_dict[i] = str(chr(65 + (i - 10)))

   else:
      num_char_dict[i] = "_" + str(chr(97 + (i - 36)))


#for i in range(0, 62):
#   if i < 10:
#      os.makedirs(num_char_dict[i])
#   elif i < 36:
#      os.makedirs("_" + num_char_dict[i])
#   else:
#      os.makedirs(num_char_dict[i])




arr = np.zeros(shape = (28, 28), dtype = 'int')

indexes = np.zeros(shape=(500))

for i in range(0, 10):
   label = -1
   for r in range(0, 28):
      for c in range(0, 28):
         arr[r][c] = (test_images[i][c][r][0]).item()

   if i % 1000 == 0:
      print("image:", i)

#   label = test_labels[i]
   label = test_labels[i]
   indexes[label] += 1

   if not os.path.exists(str(label)):
      os.makedirs(str(label))

   path_to_dir = 'imout/' + str(label)
   file_name = path_to_dir + "\\" + str(indexes[label])+ ".png"
   arr.resize((28,28))
   im = Image.fromarray(arr).convert('L')
   im.save(fp = file_name, format = 'png')
