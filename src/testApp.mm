#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	ofBackground( 127 );
   
    touchPoint.x = touchPoint.y = -1;
#ifdef QCAR 
    qcar.setup();
#else
    ofxQCAR::getInstance()->setup();
#endif    
    model[0].loadModel("aachan.bvh");
    model[0].setRotation(1, 90, 1, 0, 0);
    model[0].setScale(0.5,0.5,0.5);
    model[1].loadModel("kashiyuka.bvh");
    model[1].setRotation(1, 90, 1, 0, 0);
    model[1].setScale(0.5,0.5,0.5);
    model[2].loadModel("nocchi.bvh");
    model[2].setRotation(1, 90, 1, 0, 0);
    model[2].setScale(0.5,0.5,0.5);
    bvh[0].load("aachan.bvh");
//	bvh[1].load("kashiyuka.bvh");
//	bvh[2].load("nocchi.bvh");
    
    animationTime = 0;
    sndPlayer.loadSound("Perfume_globalsite_sound.wav");
    sndPlayer.stop();
    sndPlayer.setLoop(OF_LOOP_NORMAL);
    counter = 0;
    play_rate = play_rate_t = 1;

}
const float trackDuration = 64.28;
//----------
void testApp::update(){
    #ifdef QCAR 
    qcar.update();
    if(qcar.hasFoundMarker())
#else
    ofxQCAR::getInstance()->update();
    if( ofxQCAR::getInstance()->hasFoundMarker() )
#endif
    {
        if(!sndPlayer.getIsPlaying())sndPlayer.play();
        //counter++;
        play_rate += (play_rate_t - play_rate) * 0.3;
        sndPlayer.setSpeed(play_rate);
        //    animationTime += 0.0005;
        //    if( animationTime >= 1.0 ){
        //        animationTime = 0.0;
        //    }
        float t = (sndPlayer.getPosition() * trackDuration);
        t = t / bvh[0].getDuration();
        model[0].setNormalizedTime(t);
        model[1].setNormalizedTime(t);
        model[2].setNormalizedTime(t);
        disconnected = ofGetElapsedTimeMillis();
    }
    else {
        
        if(ofGetElapsedTimeMillis()-disconnected>5000)
        {
            
        //counter = 0;
        sndPlayer.stop();
        }
    }
}

//--------------------------------------------------------------
void testApp::draw(){
#ifdef QCAR
    qcar.draw();
#else
    ofxQCAR *qcar;
    qcar = ofxQCAR::getInstance();
    qcar->draw();
#endif    
    bool bPressed;
    bPressed = touchPoint.x >= 0 && touchPoint.y >= 0;
#ifdef QCAR
    if(qcar.hasFoundMarker())
#else
    if( qcar->hasFoundMarker() )
#endif
    {
        glDisable( GL_DEPTH_TEST );
#ifdef QCAR
#else
        ofEnableBlendMode( OF_BLENDMODE_ALPHA );
        ofSetLineWidth( 3 );
        
        bool bInside = false;
        if( bPressed )
        {
            vector<ofPoint> markerPoly;

            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)0 ) );
            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)1 ) );
            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)2 ) );
            markerPoly.push_back( qcar->getMarkerCorner( (ofxQCAR_MarkerCorner)3 ) );
            bInside = ofInsidePoly( touchPoint, markerPoly );
        }
        
        ofSetColor( ofColor( 255, 0, 255, bInside ? 150 : 50 ) );
        qcar->drawMarkerRect();
        
        ofSetColor( ofColor :: yellow );
        qcar->drawMarkerBounds();
        ofSetColor( ofColor :: cyan );
        qcar->drawMarkerCenter();
        qcar->drawMarkerCorners();
#endif        
        ofSetColor( ofColor::white );
        ofSetLineWidth( 1 );
        
        glEnable( GL_DEPTH_TEST );
        ofEnableNormalizedTexCoords();
#ifdef QCAR
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf( qcar.getProjectionMatrix().getPtr());
        
        glMatrixMode( GL_MODELVIEW );
        glLoadMatrixf(  qcar.getModelViewMatrix().getPtr());

#else
        glMatrixMode(GL_PROJECTION);
        glLoadMatrixf( qcar->getProjectionMatrix().getPtr());
        
        glMatrixMode( GL_MODELVIEW );
        glLoadMatrixf(  qcar->getModelViewMatrix().getPtr());
#endif
        model[0].drawFaces();
        model[1].drawFaces();
        model[2].drawFaces();
        
        ofDisableNormalizedTexCoords();
    }
    
    glEnable( GL_DEPTH_TEST );
//    ofSetupScreen();
//    if( bPressed )
//    {
//        ofSetColor( ofColor :: red );
//        ofDrawBitmapString( "touch x = " + ofToString( (int)touchPoint.x ), 20, 40 );
//        ofDrawBitmapString( "touch y = " + ofToString( (int)touchPoint.y ), 20, 60 );
//    }
}

//--------------------------------------------------------------
void testApp::exit(){
#ifdef QCAR
    qcar.exit();
#else
    
    ofxQCAR::getInstance()->exit();
#endif
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    touchPoint.set( touch.x, touch.y );
    play_rate_t = -1;
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    touchPoint.set( touch.x, touch.y );
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    touchPoint.set( -1, -1 );
    play_rate_t = 1;
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    cout << "Memory Warning!!!!!!\n";
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

