from tkinter import *
import tkinter as tk

class RoundedButton(tk.Canvas):
    def __init__(self, parent, width, height, cornerradius, padding, color, bg, command=None): # Initialisation
        tk.Canvas.__init__(self, parent, borderwidth=0, relief="flat", highlightthickness=0, bg=bg)
        self.command = command

        rad = 2*cornerradius
        # Creating the shape of the rounded button
        def shape():
            self.create_polygon((padding,height-cornerradius-padding,padding,cornerradius+padding,
                                 padding+cornerradius,padding,width-padding-cornerradius,padding,
                                 width-padding,cornerradius+padding,width-padding,height-cornerradius-padding,
                                 width-padding-cornerradius,height-padding,padding+cornerradius,height-padding),
                                fill=color, outline=color)
            self.create_arc((padding,padding+rad,padding+rad,padding), start=90, extent=90, fill=color,
                            outline=color)
            self.create_arc((width-padding-rad,padding,width-padding,padding+rad), start=0, extent=90,
                            fill=color, outline=color)
            self.create_arc((width-padding,height-rad-padding,width-padding-rad,height-padding), start=270,
                            extent=90, fill=color, outline=color)
            self.create_arc((padding,height-padding-rad,padding+rad,height-padding), start=180, extent=90,
                            fill=color, outline=color)


        # Configuring the button based on the shape and size given
        id = shape()
        (x0,y0,x1,y1)  = self.bbox("all")
        width = (x1-x0)
        height = (y1-y0)
        self.configure(width=width, height=height)
        # Binding the button to react to different user inputs
        self.bind("<ButtonPress-1>", self._on_press)
        self.bind("<ButtonRelease-1>", self._on_release)

    # What to do when the button is clicked
    def _on_press(self, event):
        self.configure(relief="sunken")

    # Running the given subroutine when the click is released
    def _on_release(self, event):
        self.configure(relief="raised")
        if self.command is not None:
            self.command()