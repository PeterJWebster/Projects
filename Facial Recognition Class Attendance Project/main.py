# Necessary imports

import tkinter as tk
from tkinter import *
from classes import *
import numpy as np
import cv2
import os
import shutil
import time
import csv
import pickle
from PIL import Image, ImageTk
from tensorflow import keras
import keras.utils as image
from keras_vggface.vggface import VGGFace
from keras_vggface import utils
import tensorflow.keras as keras
from tensorflow.keras.layers import Dense, GlobalAveragePooling2D
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.mobilenet import preprocess_input
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Model
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.models import load_model

root = Tk()  # Initializes the window onto which buttons etc. can be placed


# First menu the user is presented with, with only 'Login' as an option
def firstMenu():
    global canvas, loginButton, loginLabel
    canvas = Canvas(root, bg="#33BDF4", height=300, width=500)  # Intialises the background
    canvas.pack()

    loginButton = RoundedButton(root, 200, 100, 40, 3, "blue", "#33BDF4", command=login)
    loginButton.place(relx=0.3, rely=0.4)  # Places the initialized button in the middle of the screen

    canvas.create_text(250, 50, text="  FACIAL RECOGNITION \nATTENDANCE CHECKER",
                       fill="white", font=("Arial Bold", 15))  # Places the title at the top of the page

    loginLabel = Label(root, text="LOGIN", fg="white", font=("Arial Bold", 12), bg="blue")
    loginLabel.bind("<Button-1>", login)
    loginLabel.place(relx=0.44, rely=0.52)  # Places the text on top of the button

    root.mainloop()  # This means that the program begins checking for user inputs


# This menu allows user to progress after correct username and password have been entered
def login(event=None, incorrectCredentials=False):
    # Declaring the given variables as global
    global usernameInput, passwordInput, usernameLabel, passwordLabel, nextButton
    # Removing everything from the window
    canvas.delete('all')
    loginLabel.place_forget()
    loginButton.place_forget()

    # If the user has entered the details wrong, a message is displayed
    if incorrectCredentials == True:
        canvas.create_text(250, 250, text="Username or password was incorrect", fill="black", font=("Arial", 12))

    usernameInput = Entry(root, width=40)  # Initializes a box  in which the user can input
    usernameInput.place(x=125, y=80)

    passwordInput = Entry(root, width=40, show="*")
    passwordInput.place(x=125, y=160)

    canvas.create_text(50, 20, text="LOGIN", fill="blue", font=("Arial Bold", 20))

    usernameLabel = Label(root, text="Enter username:", fg="black", font=("Arial Bold", 12), bg="#33BDF4")
    usernameLabel.place(x=125, y=50)  # Places text above username box

    passwordLabel = Label(root, text="Enter password:", fg="black", font=("Arial Bold", 12), bg="#33BDF4")
    passwordLabel.place(x=125, y=130)  # Places text above password box

    # Initializes and places a button which, when clicked, passes the data in the username and password box
    # into the next function
    nextButton = tk.Button(root, text="Next", bg="blue", fg="white", font=("Arial Bold", 8),
                           command=(lambda: checkCredentials(usernameInput.get(), passwordInput.get())))
    nextButton.place(x=335, y=200)


# This function checks the inputted username and password, and returns the user to login() if they're incorrect
def checkCredentials(username, password):
    # Removing everything from the window
    canvas.delete('all')
    usernameLabel.place_forget()
    passwordLabel.place_forget()
    usernameInput.place_forget()
    passwordInput.place_forget()
    nextButton.place_forget()

    # Getting all the allowed profiles from a file and storing them in a variable
    global validUsers
    validUsers = {}
    with open("teacherProfiles.txt", newline="") as f:
        reader = csv.reader(f)

        for row in reader:
            validUsers[row[0]] = row[1]

    # Trying to see if username and password match up to valid ones in database, if so, then user is taken to main
    # menu, if not, they are taken back to login screen
    try:
        if validUsers[username] != password:
            login(None, True)
        else:
            mainMenu()
    except:
        login(None, True)


# This is the menu which the user can return to, and includes ways to get to every part of the program
def mainMenu(event=None):
    clearWindow()  # Clears the window
    try:
        exitLabel.place_forget()
    except:
        pass
    global registerClassButton, registerClassLabel, editClassButton, editClassLabel, \
        teacherProfilesButton, teacherProfilesLabel
    canvas.create_text(250, 20, text="MAIN MENU", fill="white", font=("Arial Bold", 20))

    # Initializing and placing a button that takes the user to the registerClass() function
    registerClassButton = RoundedButton(root, 200, 100, 40, 3, "blue", "#33BDF4", command=registerClass)
    registerClassButton.place(relx=0.3, rely=0.25)

    registerClassLabel = Label(root, text="REGISTER CLASS", fg="white", font=("Arial Bold", 12), bg="blue")
    registerClassLabel.bind("<Button-1>", registerClass)
    registerClassLabel.place(relx=0.35, rely=0.37)

    # Initializing and placing a button that takes the user to the editClass() function
    editClassButton = RoundedButton(root, 120, 60, 22, 3, "white", "#33BDF4", command=editClass)
    editClassButton.place(relx=0.2, rely=0.65)

    editClassLabel = Label(root, text="EDIT CLASS", fg="blue", font=("Arial Bold", 10), bg="white")
    editClassLabel.bind("<Button-1>", editClass)
    editClassLabel.place(relx=0.24, rely=0.71)

    # Initializing and placing a button that takes the user to the teacherProfiles() function
    teacherProfilesButton = RoundedButton(root, 120, 60, 22, 3, "white", "#33BDF4", command=teacherProfiles)
    teacherProfilesButton.place(relx=0.56, rely=0.65)

    teacherProfilesLabel = Label(root, text="TEACHER\nPROFILES", fg="blue", font=("Arial Bold", 10), bg="white")
    teacherProfilesLabel.bind("<Button-1>", teacherProfiles)
    teacherProfilesLabel.place(relx=0.61, rely=0.69)

    # Displaying a message if the  model isn't classed as trainable
    try:
        global trainable
        if not trainable:
            canvas.create_text(250, 275,
                               text="Class cannot be registered as there must be 8 pictures of each student",
                               fill="black", font=("Arial", 11))
            trainable = True
    except:
        pass


# This function allows students to be automatically be signed-in by standing in front of the camera, before displaying
# which students have been registered
def registerClass(event=None):
    # Checking if there are more than 7 images in each of the student directories
    global trainable
    trainable = True
    path = os.path.join(os.getcwd(), "Headshots")
    for folder in os.listdir(path):
        if len(os.listdir(os.path.join(path, folder))) < 8:
            trainable = False
    if trainable:
        # If any images have been added to the students' directories, then the model is trained
        global classChanged
        try:
            if classChanged == True:
                trainModel()
        except:
            classChanged = False

        clearWindow()


        # Initializing the global variable so that it can be checked later on
        global returnToMainMenu
        returnToMainMenu = False

        # Places the title text at the top of the screen
        canvas.create_text(130, 20, text="REGISTER CLASS", fill="blue", font=("Arial Bold", 20))

        # Initializing and place a label that can update based on how much time there is left
        global countdownLabel, exitLabel
        countdown = 120
        countdownLabel = Label(root, text="Students must be signed in by " + str(countdown // 60) + ":" + (
                    2 - len(str(countdown % 60))) * "0" + str(countdown % 60),
                               fg="blue", font=("Arial Bold", 10), bg="#33BDF4")
        countdownLabel.place(relx=0.41, rely=0.13)
        startTime = time.time()

        # Only placing an 'exit to main menu' button if one does not already exist
        try:
            exitLabel.bind("<Button-1>", exitToMainMenu)
            exitLabel.place(relx=0.90, rely=0.85)
        except:
            exitLabel = Label(root, text="Main\nMenu", fg="white", font=("Arial Bold", 8), bg="blue")
            exitLabel.bind("<Button-1>", exitToMainMenu)
            exitLabel.place(relx=0.90, rely=0.85)

        # Load the training labels
        face_label_filename = 'face-labels.pickle'
        with open(face_label_filename, "rb") as f:
            class_dictionary = pickle.load(f)

        # Load a dictionary containing all the students, alongside whether or not they have been signed-in
        class_list = [value for _, value in class_dictionary.items()]
        global classRegister
        classRegister = {}
        for student in class_list:
            classRegister[student] = False

        # Define a video capture object
        vid = cv2.VideoCapture(1)

        # Declare the width and height in variables
        width, height = 200, 150

        # Set the width and height
        vid.set(cv2.CAP_PROP_FRAME_WIDTH, width)
        vid.set(cv2.CAP_PROP_FRAME_HEIGHT, height)

        # Create a label and display it on app
        global label_widget
        label_widget = Label(root, width=350, height=200)
        label_widget.place(relx=0.15, rely=0.2)

        # Function to open camera and display it in the label_widget on app
        def registerClassLoop():
            global countdownLabel
            mins = int((countdown - (time.time() - startTime)) // 60)
            secs = str(int((countdown - (time.time() - startTime)) % 60))
            countdownLabel.config(
                text="Students must be signed in by {0}:{1}".format(mins, (2 - len(str(secs))) * "0" + secs))
            # Capture the video frame by frame
            _, frame = vid.read()

            # Convert image from one color space to other
            live_image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGBA)

            opencv_image = cv2.flip(live_image, 1)
            opencv_image = cv2.resize(opencv_image, (350, 200), interpolation=cv2.INTER_AREA)

            # Capture the latest frame and transform to image
            captured_image = Image.fromarray(opencv_image)

            # Convert captured image to photoimage
            photo_image = ImageTk.PhotoImage(image=captured_image)

            # Displaying photoimage in the label
            label_widget.photo_image = photo_image

            # Configure image in the label
            label_widget.configure(image=photo_image)

            # For detecting faces
            facecascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

            # Get the faces detected in the image
            faces = facecascade.detectMultiScale(live_image, scaleFactor=1.3, minNeighbors=5)

            if len(faces) == 1:
                image_array = np.array(live_image, "uint8")

                # Set the directory containing the images
                path = r'C:\Users\peter\OneDrive\Documents\Work\NEA_Iteration_3\Current_Frame\face.jpg'

                # Remove the original image
                os.remove(path)

                # Replace the image with only the face
                im = Image.fromarray(image_array)
                im = im.convert('RGB')
                im.save(path)

                predictFace()

            # Ensuring neither the countdown has run out, nor all the students have been signed-in, nor the user
            # has clicked 'return to main menu' before looping back
            if countdown - (time.time() - startTime) > 0 and False in classRegister.values() and \
                    returnToMainMenu == False:
                # Repeat the same process after every 100 milliseconds
                label_widget.after(100, registerClassLoop)
            else:
                vid.release()  # Stops the camera from taking input
                if returnToMainMenu == False:
                    displayPresentStudents()
                else:
                    mainMenu()

        registerClassLoop()

    else:
        mainMenu()


# This function looks at the image found in memory, and outputs the predicted class member
def predictFace():
    print("Face Detected")
    # # Allows the model to receive new variations of the images at each epoch of training
    # train_datagen = ImageDataGenerator(preprocessing_function=preprocess_input)
    # train_generator = train_datagen.flow_from_directory(
    #     'C:/Users/peter/OneDrive/Documents/Work/NEA_Iteration_3/Headshots',
    #     target_size=(224, 224),
    #     color_mode='rgb',
    #     batch_size=32,
    #     class_mode='categorical',
    #     shuffle=True)
    #
    # model = load_model('transfer_learning_trained_face_cnn_model.h5')  # Load the model
    #
    # # Turns the 2d array into a dictionary
    # class_dictionary = train_generator.class_indices
    # class_dictionary = {value: key for key, value in class_dictionary.items()}
    #
    # # Saves the class dictionary to pickle
    # face_label_filename = 'face-labels.pickle'
    # with open(face_label_filename, 'wb') as f:
    #     pickle.dump(class_dictionary, f)
    #
    # # Dimension of images
    # image_width = 224
    # image_height = 224
    #
    # # Load the training labels
    # face_label_filename = 'face-labels.pickle'
    # with open(face_label_filename, "rb") as f:
    #     class_dictionary = pickle.load(f)
    #
    # class_list = [value for _, value in class_dictionary.items()]  # Storing just the students' names
    #
    # # For detecting faces
    # facecascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
    #
    # test_image_filename = f'C:/Users/peter/OneDrive/Documents/Work/NEA_Iteration_3/Current_Frame/face.jpg'
    #
    # # Loading the image
    # imgtest = cv2.imread(test_image_filename, cv2.IMREAD_COLOR)
    # image_array = np.array(imgtest, "uint8")
    #
    # # Getting the faces detected in the image
    # faces = facecascade.detectMultiScale(imgtest, scaleFactor=1.1, minNeighbors=5)
    #
    # if len(faces) == 1:
    #     for (x_, y_, w, h) in faces:
    #         # Resizing the detected face to 224x224
    #         size = (image_width, image_height)
    #         roi = image_array[y_: y_ + h, x_: x_ + w]
    #         resized_image = cv2.resize(roi, size)
    #
    #         # Preparing the image for prediction
    #         x = image.img_to_array(resized_image)
    #         x = np.expand_dims(x, axis=0)
    #         x = utils.preprocess_input(x, version=1)
    #
    #         # Making prediction
    #         predicted_prob = model.predict(x)
    #         global classRegister, signInLabel
    #         # Changing the dictionary to show that the student has been signed-in
    #         classRegister[class_list[predicted_prob[0].argmax()]] = True
    #         # Updating the label to show who's been signed-in if it exists, if not creating a label to show it
    #         try:
    #             signInLabel.config(
    #                 text=class_list[predicted_prob[0].argmax()].replace('_', ' ') + " has been signed in")
    #             signInLabel.place(relx=0.4, rely=0.8)
    #         except:
    #             signInLabel = Label(root, text=class_list[predicted_prob[0].argmax()].replace('_', ' ')
    #                                            + " has been signed in",
    #                                 fg="blue", font=("Arial Bold", 10), bg="white")
    #             signInLabel.place(relx=0.4, rely=0.8)


# This function displays which students have been signed-in, and which haven't
def displayPresentStudents():
    clearWindow()

    exitLabel.bind("<Button-1>", mainMenu)  # Ensuring that the button takes the user to the correct place

    # Creating lists to show which students have been signed-in and which haven't
    presentStudents = []
    absentStudents = []
    global classRegister
    for _, (i, j) in enumerate(classRegister.items()):
        if j:
            presentStudents.append(i)
        else:
            absentStudents.append(i)

    # Displaying the absent and present students
    canvas.create_text(130, 20, text="REGISTER CLASS", fill="blue", font=("Arial Bold", 20))
    canvas.create_text(250, 100, text="The students who have been signed in are:", fill="blue", font=("Arial", 13))
    canvas.create_text(250, 130, text=", ".join(presentStudents).replace('_', ' ').upper(), fill="blue",
                       font=("Arial", 13))
    canvas.create_text(250, 200, text="The students who haven't been signed in are:", fill="blue", font=("Arial", 13))
    canvas.create_text(250, 230, text=", ".join(absentStudents).replace('_', ' ').upper(), fill="blue",
                       font=("Arial", 13))

    classRegister = {}


# This function, using the images stored in the students' directories, trains a convolutional neural network
# and stores it in memory
def trainModel():
    # Allows the model to receive new variations of the images at each epoch of training
    train_datagen = ImageDataGenerator(preprocessing_function=preprocess_input)
    train_generator = train_datagen.flow_from_directory(
        'C:/Users/peter/OneDrive/Documents/Work/NEA_Iteration_3/Headshots', target_size=(224, 224), color_mode='rgb',
        batch_size=32, class_mode='categorical', shuffle=True)

    train_generator.class_indices.values()
    # dict_values([0, 1, 2])
    NO_CLASSES = len(train_generator.class_indices.values())

    base_model = VGGFace(include_top=False,
                         model='vgg16',
                         input_shape=(224, 224, 3))  # Defining the model on which the cnn is based on

    # Adding the required layers to the end of the model
    x = base_model.output
    x = GlobalAveragePooling2D()(x)

    x = Dense(1024, activation='relu')(x)
    x = Dense(1024, activation='relu')(x)
    x = Dense(512, activation='relu')(x)

    # Final layer with softmax activation
    preds = Dense(NO_CLASSES, activation='softmax')(x)

    model = Model(inputs=base_model.input, outputs=preds)

    # Ensuring that the model doesn't train the first 19 layers
    for layer in model.layers[:19]:
        layer.trainable = False

    # Ensuring that the model trains the rest of the layers
    for layer in model.layers[19:]:
        layer.trainable = True

    model.compile(optimizer='Adam',
                  loss='categorical_crossentropy',
                  metrics=['accuracy'])  # Compiling the model

    model.fit(train_generator,
              batch_size=1,
              verbose=1,
              epochs=20)  # Training the model with 20 epochs

    # Creating a HDF5 file
    model.save('transfer_learning_trained_face_cnn_model_2.h5')

    # model.summary()


# This menu presents the user with to options: to add a student image, or to add/remove a student
def editClass(event=None):
    clearWindow()
    global addStudentImageButton, addStudentImageLabel, addOrRemoveStudentButton, addOrRemoveStudentLabel, exitLabel

    canvas.create_text(90, 20, text="EDIT CLASS", fill="blue", font=("Arial Bold", 20))  # Placing title at the top

    # Initializing and placing the 'add student image' button and label
    addStudentImageButton = RoundedButton(root, 150, 75, 30, 3, "white", "#33BDF4", command=selectStudent)
    addStudentImageButton.place(relx=0.15, rely=0.35)

    addStudentImageLabel = Label(root, text="ADD STUDENT\nIMAGE", fg="blue", font=("Arial Bold", 10), bg="white")
    addStudentImageLabel.bind("<Button-1>", selectStudent)
    addStudentImageLabel.place(relx=0.2, rely=0.41)

    # Initializing and placing the 'add/remove student' button and label
    addOrRemoveStudentButton = RoundedButton(root, 150, 75, 30, 3, "white", "#33BDF4",
                                             command=selectAddedOrRemovedStudent)
    addOrRemoveStudentButton.place(relx=0.56, rely=0.35)

    addOrRemoveStudentLabel = Label(root, text="ADD/REMOVE\nSTUDENT", fg="blue", font=("Arial Bold", 10), bg="white")
    addOrRemoveStudentLabel.bind("<Button-1>", selectAddedOrRemovedStudent)
    addOrRemoveStudentLabel.place(relx=0.62, rely=0.41)

    # Ensuring that there is a 'return to main menu' button that the user can click
    try:
        exitLabel.bind("<Button-1>", mainMenu)
        exitLabel.place(relx=0.90, rely=0.85)
    except:
        exitLabel = Label(root, text="Main\nMenu", fg="white", font=("Arial Bold", 8), bg="blue")
        exitLabel.bind("<Button-1>", mainMenu)
        exitLabel.place(relx=0.90, rely=0.85)


# This function allows the user to select a valid student from the class to add an image to
def selectStudent(event=True):
    clearWindow()
    canvas.create_text(90, 20, text="EDIT CLASS", fill="blue", font=("Arial Bold", 20))
    # Outputting a message if the user hasn't chosen a valid user
    try:
        global valid
        if valid == False:
            canvas.create_text(250, 250, text="Please enter a valid student", fill="black", font=("Arial", 12))
            valid = True
    except:
        pass

    # Initializing and placing a box in which the user can provide input
    global selectStudentInput, enterButton
    selectStudentInput = Entry(root, width=40)
    selectStudentInput.place(x=125, y=135)

    cwd = os.getcwd()  # Getting the current working directory

    # Setting the directory containing the images
    images_dir = os.path.join(cwd, 'Headshots')

    # Defining what the valid users are
    global students
    students = os.listdir(images_dir)

    canvas.create_text(245, 110, text="Enter student to add image to:", fill="black", font=("Arial Bold", 12))

    # Initializing and placing a button that lets the user continue with the inputs they've given
    enterButton = tk.Button(root, text="Enter", bg="blue", fg="white", font=("Arial Bold", 8),
                            command=(lambda: addStudentImage(selectStudentInput.get().replace(" ", "_"))))
    enterButton.place(x=335, y=200)

    exitLabel.bind("<Button-1>", mainMenu)


# This function displays a live camera feed and allows the user to take a picture by pressing a key, it then
# stores the image under the selected student's directory
def addStudentImage(selectedStudent):
    global students

    exitLabel.bind("<Button-1>", exitToMainMenu)  # Binding the exit label so that the live image will be cancelled

    # Checking that the specified user in valid
    if selectedStudent.lower() in [x.lower() for x in students]:
        canvas.create_text(250, 50, text="Press 'P' to capture image", fill="blue", font=("Arial Bold", 10))

        global returnToMainMenu
        returnToMainMenu = False

        # Defining a video capture object
        vid = cv2.VideoCapture(1)

        # Declaring the width and height in variables
        width, height = 200, 150

        # Setting the width and height
        vid.set(cv2.CAP_PROP_FRAME_WIDTH, width)
        vid.set(cv2.CAP_PROP_FRAME_HEIGHT, height)

        # Creating a label and displaying it on app
        global label_widget
        label_widget = Label(root, width=350, height=200)
        label_widget.place(relx=0.15, rely=0.2)

        def open_camera():
            # Capturing the video frame by frame
            _, frame = vid.read()

            # Converting image from one color space to other
            live_image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGBA)

            opencv_image = cv2.flip(live_image, 1)
            opencv_image = cv2.resize(opencv_image, (350, 200), interpolation=cv2.INTER_AREA)

            # Capturing the latest frame and transform to image
            captured_image = Image.fromarray(opencv_image)

            # Converting captured image to photoimage
            photo_image = ImageTk.PhotoImage(image=captured_image)

            # Displaying photoimage in the label
            label_widget.photo_image = photo_image

            # Configuring image in the label
            label_widget.configure(image=photo_image)

            # Checking if user has chosen to return to main menu
            if returnToMainMenu:
                vid.release()
                mainMenu()
            else:
                try:
                    global done
                    if done == True:
                        vid.release()
                    else:
                        label_widget.after(10, open_camera)
                except:
                    label_widget.after(10, open_camera)

        def takePicture(event):
            # Capturing the video frame by frame
            _, frame = vid.read()

            # Converting image from one color space to other
            live_image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGBA)

            # Capturing the latest frame and transform to image
            captured_image = Image.fromarray(live_image)

            # Specfying the path where the image should be saved
            path = r'C:\Users\peter\OneDrive\Documents\Work\NEA_Iteration_3\Headshots'
            path = os.path.join(path, selectedStudent)
            path = os.path.join(path, selectedStudent.replace("_", " ").title().replace(" ", "_") + "_" + str(
                len(os.listdir(path)) + 1) + ".jpg")

            captured_image = captured_image.convert('RGB')

            captured_image.save(path)  # Saving image
            # Changing global variables to reflect the change
            global done, classChanged
            done = True
            classChanged = True
            preprocessImages()
            if returnToMainMenu:
                mainMenu()

        open_camera()
        root.bind("p", takePicture)
    else:
        global valid
        valid = False
        selectStudent()


# This function lets the user enter a name of a student (that eiter exists or doesn't)
def selectAddedOrRemovedStudent(event=True):
    clearWindow()
    canvas.create_text(90, 20, text="EDIT CLASS", fill="blue", font=("Arial Bold", 20))
    # Displaying message if the user hasn't entered anything
    try:
        global valid
        if valid == False:
            canvas.create_text(250, 250, text="Name can't be longer than 30 characters", fill="black", font=("Arial", 12))
            valid = True
    except:
        pass

    # Initializing and placing a box in which the user can enter a student's name
    global selectAddedOrRemovedStudentInput, enterButton
    selectAddedOrRemovedStudentInput = Entry(root, width=40)
    selectAddedOrRemovedStudentInput.place(x=125, y=135)

    # Loading the students in the class
    global students
    images_dir = os.path.join(os.getcwd(), 'Headshots')
    students = os.listdir(images_dir)

    canvas.create_text(245, 110,
                       text="Enter student to be added or removed:",
                       fill="black",
                       font=("Arial Bold", 12))

    # Initializing and placing a button which the user presses after they're done entering
    enterButton = tk.Button(root, text="Enter", bg="blue", fg="white", font=("Arial Bold", 8),
                            command=(
                                lambda: addOrRemoveStudent(selectAddedOrRemovedStudentInput.get().replace(" ", "_"))))
    enterButton.place(x=335, y=200)
    exitLabel.bind("<Button-1>", mainMenu)


# This function either removes a student if the specified student exists, or adds one if they don't
def addOrRemoveStudent(addedOrRemovedStudent):
    global addOrRemoveLabel, students
    # Loading the students in the class
    images_dir = os.path.join(os.getcwd(), 'Headshots')
    students = os.listdir(images_dir)

    # Ensuring that the user input exists, and is of the correct length
    if addedOrRemovedStudent != "" and len(addedOrRemovedStudent) < 30:
        # Specifying the path that should be deleted/created
        addedOrRemovedStudent = addedOrRemovedStudent.replace("_", " ").title().replace(" ", "_")
        path = os.path.join(os.getcwd(), 'Headshots')
        path = os.path.join(path, addedOrRemovedStudent)

        # Checking if the user input is already a student or not
        if addedOrRemovedStudent.lower() in [x.lower() for x in students]:
            shutil.rmtree(path)
            # Editing the label if it already exists, creating one if it doesn't
            try:
                addOrRemoveLabel.config(text="Student successfully removed")
            except:
                addOrRemoveLabel = Label(root, text="Student successfully removed", fg="blue", font=("Arial Bold", 10),
                                         bg="#33BDF4")
        else:
            os.mkdir(path)
            try:
                addOrRemoveLabel.config(text="Student successfully added")
            except:
                addOrRemoveLabel = Label(root, text="Student successfully added", fg="blue", font=("Arial Bold", 10),
                                         bg="#33BDF4")
        addOrRemoveLabel.place(relx=0.32, rely=0.55)
        global classChanged
        classChanged = True
    else:
        global valid
        valid = False
        selectAddedOrRemovedStudent()


# This function goes through every image in memory and makes sure that they are in the correct format to be fed
# through the neural network
def preprocessImages():
    # Allows the model to receive new variations of the images at each epoch of training
    train_datagen = ImageDataGenerator(preprocessing_function=preprocess_input)
    train_generator = train_datagen.flow_from_directory(
        'C:/Users/peter/OneDrive/Documents/Work/NEA_Iteration_3/Headshots', target_size=(224, 224), color_mode='rgb',
        batch_size=32, class_mode='categorical', shuffle=True)

    train_generator.class_indices.values()
    # dict_values([0, 1, 2])
    NO_CLASSES = len(train_generator.class_indices.values())

    # Dimension of images
    image_width = 224
    image_height = 224

    # Detecting faces
    facecascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

    cwd = os.getcwd()  # Getting current working directory

    # Setting the directory containing the images
    images_dir = os.path.join(cwd, 'Headshots')

    current_id = 0
    label_ids = {}

    # Iterating through all the files in each subdirectory
    for root, _, files in os.walk(images_dir):
        for file in files:
            if file.endswith("png") or file.endswith("jpg") or file.endswith("jpeg"):
                # Specifying the path of the image
                path = os.path.join(root, file)
                if Image.open(path).width != 224 or Image.open(path).height != 224:
                    # Getting the student name
                    label = os.path.basename(root).replace(" ", ".").lower()

                    # Adding the label (key) and its number (value)
                    if not label in label_ids:
                        label_ids[label] = current_id
                        current_id += 1

                    # Loading the image
                    imgtest = cv2.imread(path, cv2.IMREAD_COLOR)
                    image_array = np.array(imgtest, "uint8")

                    # Getting the faces detected in the image
                    faces = facecascade.detectMultiScale(imgtest, scaleFactor=1.1, minNeighbors=5)
                    print(faces)

                    # If anything but exactly 1 face is detected, skip this photo
                    if len(faces) != 1:
                        canvas.create_text(250, 280, text="There must be exactly one face in the image", fill="blue",
                                           font=("Arial Bold", 10))
                        # Removing the original image
                        os.remove(path)
                        continue
                    else:
                        canvas.create_text(250, 275, text="Image successfully added", fill="blue",
                                           font=("Arial Bold", 10))

                    # Saving the detected face and associating them with the label
                    for (x_, y_, w, h) in faces:
                        # Resizing the detected face to 224x224
                        size = (image_width, image_height)

                        # Detected face region
                        roi = image_array[y_: y_ + h, x_: x_ + w]

                        # Resizing the detected head to target size
                        resized_image = cv2.resize(roi, size)
                        image_array = np.array(resized_image, "uint8")

                        # Removing the original image
                        os.remove(path)

                        # Replacing the image with only the face
                        im = Image.fromarray(image_array)
                        im.save(path)


# This menu presents the user with two options: to delete a teacher profile, or to add/edit a teacher profile
def teacherProfiles(event=None):
    clearWindow()
    global deleteProfileButton, addEditProfileButton, deleteProfileLabel, addEditProfileLabel, exitLabel
    # Displaying a message if there is only one profile, thus making deletion impossible
    try:
        global allowedDeletion
        if allowedDeletion == False:
            canvas.create_text(250, 250, text="There must always be at least one user profile", fill="black",
                               font=("Arial", 12))
            allowedDeletion = True
    except:
        pass

    canvas.create_text(150, 20, text="TEACHER PROFILES", fill="blue", font=("Arial Bold", 20))

    # Initializing and placing the 'delete profile' button
    deleteProfileButton = RoundedButton(root, 150, 75, 30, 3, "white", "#33BDF4", command=selectDeletedProfile)
    deleteProfileButton.place(relx=0.15, rely=0.35)

    deleteProfileLabel = Label(root, text="DELETE PROFILE", fg="blue", font=("Arial Bold", 10), bg="white")
    deleteProfileLabel.bind("<Button-1>", selectDeletedProfile)
    deleteProfileLabel.place(relx=0.185, rely=0.43)

    # Initializing and placing the 'add/edit profile' button
    addEditProfileButton = RoundedButton(root, 150, 75, 30, 3, "white", "#33BDF4", command=selectAddedOrEditedProfile)
    addEditProfileButton.place(relx=0.56, rely=0.35)

    addEditProfileLabel = Label(root, text="ADD/EDIT PROFILE", fg="blue", font=("Arial Bold", 10), bg="white")
    addEditProfileLabel.bind("<Button-1>", selectAddedOrEditedProfile)
    addEditProfileLabel.place(relx=0.59, rely=0.43)

    # Ensuring the placement of an exit button for the user
    try:
        exitLabel.bind("<Button-1>", mainMenu)
        exitLabel.place(relx=0.90, rely=0.85)
    except:
        exitLabel = Label(root, text="Main\nMenu", fg="white", font=("Arial Bold", 8), bg="blue")
        exitLabel.bind("<Button-1>", mainMenu)
        exitLabel.place(relx=0.90, rely=0.85)


# This function takes user input on the name of the teacher profiles which they wish to remove
def selectDeletedProfile(event=None):
    global validUsers, deleteProfileInput, deleteProfileText, enterButton
    # Checking that the user is allowed to delete any profiles
    if len(validUsers) <= 1:
        global allowedDeletion
        allowedDeletion = False
        teacherProfiles()
    else:
        clearWindow()
        canvas.create_text(150, 20, text="TEACHER PROFILES", fill="blue", font=("Arial Bold", 20))
        # Display a message if the user hasn't entered a valid profile
        try:
            global valid
            if valid == False:
                canvas.create_text(250, 250, text="Please enter a valid profile", fill="black", font=("Arial", 12))
                valid = True
        except:
            pass

        # Initialize and place a box which the user can input into
        deleteProfileInput = Entry(root, width=40)
        deleteProfileInput.place(x=125, y=135)

        # Getting the students' names
        validUsersKeys = []
        for key in validUsers.keys():
            validUsersKeys.append(key)

        canvas.create_text(255, 110,
                           text="Enter profile to be deleted:\n(options: " + ", ".join(validUsersKeys) + ")",
                           fill="black",
                           font=("Arial Bold", 12))  # Displaying options for user input

        # Initializing and placing a button for the user to press after they have finished their input
        enterButton = tk.Button(root, text="Enter", bg="blue", fg="white", font=("Arial Bold", 8),
                                command=(lambda: deleteProfile(deleteProfileInput.get())))
        enterButton.place(x=335, y=200)


# This function removes the specified teacher from the valid users list, and updates the database to relect this
# change
def deleteProfile(deletedProfile):
    global validUsers, valid
    try:
        # Deleting file contents
        del validUsers[deletedProfile]
        with open("teacherProfiles.txt", "r+", newline="") as fo:
            fo.truncate(0)
        # Writing to file line by line
        for _, (i, j) in enumerate(validUsers.items()):
            with open("teacherProfiles.txt", "a", newline="") as fo:
                writer = csv.writer(fo)
                writer.writerow([i, j])
        teacherProfiles()
    except:
        valid = False
        selectDeletedProfile()


# This function take the user's input on the username and password of the teacher profile which they would like
# to edit/add
def selectAddedOrEditedProfile(event=None):
    global addOrEditProfileUsername, addOrEditProfilePassword, enterButton
    clearWindow()
    canvas.create_text(150, 20, text="TEACHER PROFILES", fill="blue", font=("Arial Bold", 20))

    # Displaying a message if the user hasn't entered anything
    try:
        global valid
        if valid == False:
            canvas.create_text(250, 260, text="Must enter username and password", fill="black", font=("Arial", 12))
            valid = True
    except:
        pass

    # Initializing and placing two boxes for the user to enter a username and password
    addOrEditProfileUsername = Entry(root, width=40)
    addOrEditProfileUsername.place(x=125, y=130)

    addOrEditProfilePassword = Entry(root, width=40)
    addOrEditProfilePassword.place(x=125, y=180)

    canvas.create_text(250, 110, text="Enter profile to be added/edited:\nUsername:", fill="black",
                       font=("Arial Bold", 12))
    canvas.create_text(170, 170, text="Password:", fill="black", font=("Arial Bold", 12))

    enterButton = tk.Button(root, text="Enter", bg="blue", fg="white", font=("Arial Bold", 8),
                            command=(lambda: addOrEditProfile(addOrEditProfileUsername.get(),
                                                              addOrEditProfilePassword.get())))
    enterButton.place(x=330, y=210)


# This function either adds a teacher profile with the specified username and password if the username doesn't
# already exist, if it does, then the password of that profile is updated.
def addOrEditProfile(addedOrEditedProfileUsername, addedOrEditedProfilePassword):
    global validUsers
    # Checking if the user has entered anything
    if addedOrEditedProfileUsername != "" and addedOrEditedProfilePassword != "":
        # Making the item under the key of the given username the given password
        validUsers[addedOrEditedProfileUsername] = addedOrEditedProfilePassword
        # Updating file to reflect change
        with open("teacherProfiles.txt", "r+", newline="") as fo:
            fo.truncate(0)
        for _, (i, j) in enumerate(validUsers.items()):
            with open("teacherProfiles.txt", "a", newline="") as fo:
                writer = csv.writer(fo)
                writer.writerow([i, j])
        teacherProfiles()
    else:
        global valid
        valid = False
        selectAddedOrEditedProfile()


# This function goes through every label and button that could show up on screen, and removes them
def clearWindow():
    canvas.delete('all')
    try:
        registerClassLabel.place_forget()
    except:
        pass
    try:
        editClassLabel.place_forget()
    except:
        pass
    try:
        teacherProfilesLabel.place_forget()
    except:
        pass
    try:
        registerClassButton.place_forget()
    except:
        pass
    try:
        editClassButton.place_forget()
    except:
        pass
    try:
        teacherProfilesButton.place_forget()
    except:
        pass
    try:
        countdownLabel.place_forget()
    except:
        pass
    try:
        label_widget.place_forget()
    except:
        pass
    try:
        signInLabel.place_forget()
    except:
        pass
    try:
        deleteProfileButton.place_forget()
    except:
        pass
    try:
        addEditProfileButton.place_forget()
    except:
        pass
    try:
        deleteProfileLabel.place_forget()
    except:
        pass
    try:
        addEditProfileLabel.place_forget()
    except:
        pass
    try:
        deleteProfileInput.place_forget()
    except:
        pass
    try:
        enterButton.place_forget()
    except:
        pass
    try:
        addOrEditProfileUsername.place_forget()
    except:
        pass
    try:
        addOrEditProfilePassword.place_forget()
    except:
        pass
    try:
        addStudentImageButton.place_forget()
    except:
        pass
    try:
        addOrRemoveStudentButton.place_forget()
    except:
        pass
    try:
        addStudentImageLabel.place_forget()
    except:
        pass
    try:
        addOrRemoveStudentLabel.place_forget()
    except:
        pass
    try:
        selectStudentInput.place_forget()
    except:
        pass
    try:
        selectAddedOrRemovedStudentInput.place_forget()
    except:
        pass
    try:
        addOrRemoveLabel.place_forget()
    except:
        pass


# This function changes the values of some global variables so that the program knows if the user wishes to
# return to the main menu
def exitToMainMenu(event=None):
    global returnToMainMenu
    returnToMainMenu = True
    global done
    try:
        if done == True:
            done = False
            mainMenu()
    except:
        pass


firstMenu()