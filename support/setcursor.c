#include <stdlib.h>
#include <X11/Xlib.h>

int main(int argc,const char **argv) {
	Display *dpy = XOpenDisplay(NULL);
	Window win, root, child = RootWindow(dpy, DefaultScreen(dpy));
        Cursor cursor;
        int root_x_return, root_y_return, win_x_return, win_y_return;
        unsigned int mask_return;
        static XColor fgcolour, bgcolour;

	if (argc != 2) return -1;

        fgcolour.red = 0xffff;
        bgcolour.red = 0x8000;
        bgcolour.blue = 0x2000;
        bgcolour.green = 0x4000;

	while (child)
            XQueryPointer(dpy, (win=child),
                          &root, &child,
                          &root_x_return, &root_y_return,
                          &win_x_return, &win_y_return,
                          &mask_return);
        cursor = XCreateFontCursor(dpy, atoi(argv[1]));
        XRecolorCursor(dpy, cursor, &fgcolour, &bgcolour);
	XDefineCursor(dpy, win, cursor);
	XFlush(dpy);
	return 0;
}
