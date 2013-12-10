//Virtual Analog One Pole Filter
//Ported from Will Pirkle's app notes/C++ project files:
//http://www.willpirkle.com/project-gallery/app-notes/#AN6
//Ported by Bruce Lott, Ness Morris, and Owen Vallis
//December 2013
public class CVAOnePoleFilterEx
{
    // common variables
    second/samp => float m_dSampleRate; //sample rate
    float m_dFc;  // cutoff frequency
    
    // Trapezoidal Integrator Components
    // variables
    float m_dAlpha;  // Feed Forward coeff
    float m_dBeta;  // Feed Back coeff from s + FB_IN
    // extended functionality variables
    float m_dGamma;  // Pre-Gain
    float m_dDelta;  // FB_IN Coeff
    float m_dEpsilon;  // extra factor for local FB
    float m_da0;  // filter gain
    float m_dFeedback; // Feed Back storage register (not a delay register)
    float m_dZ1; // our z-1 storage location
    
    //Functions
    fun void init(){
        1.0 => m_dAlpha;
        -1.0 => m_dBeta;
        1.0 => m_dGamma;
        0.0 => m_dDelta;
        1.0 => m_dEpsilon;
        0.0 => m_dFeedback;
        1.0 => m_da0;
        reset();
    }
    // provide access to our feedback output
    fun float getFeedbackOutput(){ 
        return m_dBeta*(m_dZ1 + m_dFeedback*m_dDelta); 
    } //maybe  
    // provide access to set our feedback input
    fun void setFeedback(float fb){ fb => m_dFeedback;}
    // for s_N only; not used in the Diode Ladder
    fun float getStorageValue(){ return m_dZ1; }
    // flush buffer
    fun void reset(){ 0 => m_dZ1; }
    
    fun float doFilter(float xn)
    {        
        (xn*m_dGamma + m_dFeedback + m_dEpsilon*getFeedbackOutput()) => float x_in;
        (m_da0*x_in - m_dZ1)*m_dAlpha => float vn;
        vn + m_dZ1 => float out;
        vn + out => m_dZ1;

        return out;
    }
}