# MNIST dataset classification
import numpy as np
import matplotlib.pyplot as plt

# tensorflow 2.0
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras.models import Sequential
from tensorflow.keras.utils import to_categorical

# MNIST train
(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()
print("Train dataset: X: {}, Y: {}".format(x_train.shape, y_train.shape))
print("Test dataset: X: {}, Y: {}".format(x_test.shape, y_test.shape))

# Check range of values in X
print("\nX has values between {} and {}".format(np.min(x_train), np.max(x_train)))

# Check how many labels there are
n_labels = 10
train_size = y_train.shape[0]
test_size = y_test.shape[0]

# Normalize the imagesn 
x_norm_train = (x_train - np.mean(x_train, axis=(1,2), keepdims=True)).reshape(train_size, -1)
x_norm_test = (x_test - np.mean(x_test, axis=(1,2), keepdims=True)).reshape(test_size, -1)

# Onehot encoding labels
y_oh_train = to_categorical(y_train, num_classes=n_labels)
y_oh_test = to_categorical(y_test, num_classes=n_labels)
#print("Train dataset: X: {}, Y: {}".format(x_train, y_train))
#print("Test dataset: X: {}, Y: {}".format(x_test, y_test))

# build the model
n_in = 784 # Number of inputs 28x28
n_out = 10 # Number of labels (digits)

# Creating a sequential model with 3 layers
# Two layers have relu activation and last layer has a softmax activation
model1 = tf.keras.Sequential()
model1.add(layers.Dense(100, activation='relu', input_shape=(n_in,)))
model1.add(layers.Dense(50, activation='relu'))
# Add another dense layer with 50 nodes and activation relu
model1.add(layers.Dense(n_out, activation='softmax'))

# Compile the model
model1.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['acc'])

# Print a summary of the model
model1.summary()

# train and keep history
history1 = model1.fit(x_norm_train, y_oh_train, epochs=5, batch_size=32, validation_split=0.2)

# test model
test_res1 = model1.evaluate(x_norm_test, y_oh_test, verbose=0)
print("Test loss: {} , Test accuracy: {}".format(test_res1[0], test_res1[1]))

# print some of the training history
print("History object records {}".format(history1.history.keys()))
print("For example, validation accuracy: {}".format(history1.history.get('val_acc')))
plt.plot(history1.history['loss'], label='loss')
plt.plot(history1.history['acc'], label='accuracy')
plt.legend() 