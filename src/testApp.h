#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

#include "ofxQCAR.h"
#include "ofxAssimpModelLoader.h"
#include "ofxBvh.h"
//#define QCAR
class testApp : public ofxiPhoneApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        ofPoint touchPoint;
    ofxAssimpModelLoader model[3];
    ofxBvh bvh[1];
    float animationTime;
    
    ofSoundPlayer sndPlayer;
    float counter;
    float play_rate, play_rate_t;
    float disconnected;
#ifdef QCAR 
    ofxQCAR qcar;
#endif
};


