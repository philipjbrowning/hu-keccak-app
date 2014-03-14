#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
// #include <GL/glu.h>
// #include <GL/glut.h>
#include <stdlib.h>
#include <stdio.h>

/*  Create a texture  */
#define ImageWidth 5
#define ImageHeight 5
static GLubyte checkImage[ImageHeight][ImageWidth][4];    //Assigns a 5X5 pixel with RGBA component
 
static GLuint texName;

/*
void makeImage(void)
{
   int i, j, c;
    
   for (i = 0; i < ImageHeight; i++) {
      for (j = 0; j < ImageWidth; j++) {
         //c = ((((i&0x8)==0)^((j&0x8))==0))*255;

/* simply indicates if i or j are even mark with the color red else mark 
 black. ^ represents XOR operand */
/*
	if(((i%2) ==0) ^ ((j%2)==0)) {			
         checkImage[i][j][0] = (GLubyte) 250;
         checkImage[i][j][1] =(GLubyte) 0;
         checkImage[i][j][2] = (GLubyte) 0;
         checkImage[i][j][3] = (GLubyte) 255;
	}
else{
	checkImage[i][j][0] = (GLubyte) 0;
         checkImage[i][j][1] = (GLubyte) 0;
         checkImage[i][j][2] = (GLubyte) 0;
         checkImage[i][j][3] = (GLubyte) 255;
	}
	
      }
   }
}
*/

/*
void init(void)
{    
   glClearColor (1.0,1.0, 1.0, 1.0);
   glShadeModel(GL_FLAT);
   glEnable(GL_DEPTH_TEST);

   makeImage();
   glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

   glGenTextures(1, &texName);
   glBindTexture(GL_TEXTURE_2D, texName);

   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, 
                   GL_NEAREST);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, 
                   GL_NEAREST);
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, ImageWidth, 
                ImageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, 
                checkImage);
}
*/

/*
void display(void)			//Draws 4 squares 
{
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   glEnable(GL_TEXTURE_2D);
   glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
   glBindTexture(GL_TEXTURE_2D, texName);
   glBegin(GL_QUADS);

   glTexCoord2f(0.0, 0.0); glVertex3f(-5.0, -1.0, 0.0);
   glTexCoord2f(0.0, 1.0); glVertex3f(-5.0, 1.0, 0.0);
   glTexCoord2f(1.0, 1.0); glVertex3f(-3.0, 1.0, 0.0);
   glTexCoord2f(1.0, 0.0); glVertex3f(-3.0, -1.0, 0.0);


   glTexCoord2f(0.0, 0.0); glVertex3f(-2.0, -1.0, 0.0);
   glTexCoord2f(0.0, 1.0); glVertex3f(-2.0, 1.0, 0.0);
   glTexCoord2f(1.0, 1.0); glVertex3f(0.0, 1.0, 0.0);
   glTexCoord2f(1.0, 0.0); glVertex3f(0.0, -1.0, 0.0);


   glTexCoord2f(0.0, 0.0); glVertex3f(1.0, -1.0, 0.0);
   glTexCoord2f(0.0, 1.0); glVertex3f(1.0, 1.0, 0.0);
   glTexCoord2f(1.0, 1.0); glVertex3f(3.0, 1.0, 0.0);
   glTexCoord2f(1.0, 0.0); glVertex3f(3.0, -1.0, 0.0);


   glTexCoord2f(0.0, 0.0); glVertex3f(4.0, -1.0, 0.0);
   glTexCoord2f(0.0, 1.0); glVertex3f(4.0, 1.0, 0.0);
   glTexCoord2f(1.0, 1.0); glVertex3f(6.0, 1.0, 0.0);
   glTexCoord2f(1.0, 0.0); glVertex3f(6.0, -1.0, 0.0);


   
   glEnd();
   glFlush();
   glDisable(GL_TEXTURE_2D);
}
*/

/*
void reshape(int w, int h)
{
   glViewport(0, 0, (GLsizei) w, (GLsizei) h);
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   gluPerspective(95.0, (GLfloat) w/(GLfloat) h, 1.0, 30.0);
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   glTranslatef(0.0, 0.0, -3.6);
}
*/

/*
void keyboard (unsigned char key, int x, int y)
{
   switch (key) {
      case 27:
         exit(0);
         break;
      default:
         break;
   }

*/

/*
int main(int argc, char** argv)
{
   glutInit(&argc, argv);
   glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH);
   glutInitWindowSize(250, 250);
   glutInitWindowPosition(100, 100);
   glutCreateWindow(argv[0]);
   init();
   glutDisplayFunc(display);
   glutReshapeFunc(reshape);
   //glutKeyboardFunc(keyboard);
   glutMainLoop();
   return 0; 
}
*/