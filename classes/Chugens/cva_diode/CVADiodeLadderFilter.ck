public class CVADiodeLadderFilter extends Chugen{
    CVAOnePoleFilterEx m_LPF1;
    CVAOnePoleFilterEx m_LPF2;
    CVAOnePoleFilterEx m_LPF3;
    CVAOnePoleFilterEx m_LPF4;
    float m_dGAMMA; // Gamma see App Note 
    // our feedback S values (global)
    float m_dSG1; 
    float m_dSG2; 
    float m_dSG3; 
    float m_dSG4; 
    float m_dK;
    float m_dFc;
    float m_nSampleRate;
    float m_dSaturation;
    int m_uNLPType;
    int m_NonLinearProcessing;
    
    //Functions
    fun float q(){ return m_dK; }
    fun float q(float nq){
        nq => m_dK;
        updateFilter();
        return m_dK;
    }
    
    fun float cutoff(){ return m_dFc; }
    fun float cutoff(float nfc){
        nfc => m_dFc;
        updateFilter();
        return m_dFc;
    }
    
    fun void init(){
        second/samp => m_nSampleRate;
        4 => m_dSaturation;
        1 => m_NonLinearProcessing;
        1 => m_uNLPType;
        // Finish initializations here
        0.0 => m_dGAMMA;
        1 => m_dK; //RESONANCE?!?!?!
        // our feedback S values (global)
        0.0 => m_dSG1;
        0.0 => m_dSG2;
        0.0 => m_dSG3;
        0.0 => m_dSG4;
        // Filter coeffs that are constant
        // set a0s
        1.0 => m_LPF1.m_da0;
        0.5 => m_LPF2.m_da0;
        0.5 => m_LPF3.m_da0;
        0.5 => m_LPF4.m_da0;
        // last LPF has no feedback path
        1.0 => m_LPF4.m_dGamma;
        0.0 => m_LPF4.m_dDelta;
        0.0 => m_LPF4.m_dEpsilon;
        m_LPF4.setFeedback(0.0);
        
        reset();
        updateFilter();
        cutoff(20000);
        q(0.1);
        //<<<m_dK, m_dFc, "samprate", m_nSampleRate,
        //m_dSaturation, m_uNLPType, m_NonLinearProcessing>>>;
    }
    
    fun void reset(){
        m_LPF1.reset(); m_LPF2.reset();
        m_LPF3.reset(); m_LPF4.reset();
        m_LPF1.setFeedback(0.0); m_LPF2.setFeedback(0.0); 
        m_LPF3.setFeedback(0.0); m_LPF4.setFeedback(0.0); 
    }
    
    // recalc the coeffs
    fun void updateFilter(){
        // calculate alphas
        2.0*pi*m_dFc => float wd; 
        1.0/m_nSampleRate => float T; //chout<="T: "<=T<=IO.nl();
        (2.0/T)*Math.tan(wd*T/2.0) => float wa; 
        wa*T/2.0 => float g;//chout<="g: "<=g<=IO.nl();
        // Big G's
        float G1, G2, G3, G4;
        (0.5*g)/(1.0 + g) => G4;
        (0.5*g)/(1.0 + g - 0.5*g*G4) => G3;
        (0.5*g)/(1.0 + g - 0.5*g*G3) => G2;
        g/(1.0 + g - g*G2) => G1;
        
        // our big G value GAMMA
        G4*G3*G2*G1 => m_dGAMMA;
        
        G4*G3*G2 => m_dSG1; 
        G4*G3 => m_dSG2; 
        G4 => m_dSG3; 
        1.0 => m_dSG4; 
        // set alphas
        g/(1.0 + g) => m_LPF1.m_dAlpha;//chout<="alpha: "<=m_LPF1.m_dAlpha<=IO.nl();
        g/(1.0 + g) => m_LPF2.m_dAlpha;
        g/(1.0 + g) => m_LPF3.m_dAlpha;
        g/(1.0 + g) => m_LPF4.m_dAlpha;
        // set betas
        1.0/(1.0 + g - g*G2) => m_LPF1.m_dBeta ;//chout<=m_LPF1.m_dBeta<=IO.nl();
        1.0/(1.0 + g - 0.5*g*G3) => m_LPF2.m_dBeta;
        1.0/(1.0 + g - 0.5*g*G4) => m_LPF3.m_dBeta;
        1.0/(1.0 + g) => m_LPF4.m_dBeta ;
        
        // set gammas
        1.0 + G1*G2 => m_LPF1.m_dGamma;
        1.0 + G2*G3 => m_LPF2.m_dGamma;
        1.0 + G3*G4 => m_LPF3.m_dGamma;
        // m_LPF4.m_dGamma = 1.0; // constant - done in constructor
        
        // set deltas
        g => m_LPF1.m_dDelta;
        0.5*g => m_LPF2.m_dDelta;
        0.5*g => m_LPF3.m_dDelta;
        // m_LPF4.m_dDelta = 0.0; // constant - done in constructor
        // set epsilons
        G2 => m_LPF1.m_dEpsilon;
        G3 => m_LPF2.m_dEpsilon;
        G4 => m_LPF3.m_dEpsilon;
        // m_LPF4.m_dEpsilon = 0.0; // constant - done in constructor 
    }
    
    fun float tick(float in){
        return doFilter(in);
    }
    
    // do the filter
    fun float doFilter(float xn){
        // m_LPF4.setFeedback(0.0); // constant - done in constructor
        m_LPF3.setFeedback(m_LPF4.getFeedbackOutput());
        m_LPF2.setFeedback(m_LPF3.getFeedbackOutput());
        m_LPF1.setFeedback(m_LPF2.getFeedbackOutput());
        // form input
        m_dSG1*m_LPF1.getFeedbackOutput() + 
        m_dSG2*m_LPF2.getFeedbackOutput() +
        m_dSG3*m_LPF3.getFeedbackOutput() +
        m_dSG4*m_LPF4.getFeedbackOutput() => float SIGMA;
        
        //"cheap" nonlinear model; just process input
        if(m_NonLinearProcessing > 0)
        {
            //Normalized Version
            if(m_uNLPType > 0)
                (1.0/Math.tanh(m_dSaturation))*Math.tanh(m_dSaturation*xn) => xn;
            else
                Math.tanh(m_dSaturation*xn) => xn;
        }
        
        // form the input to the loop
        (xn - m_dK*SIGMA)/(1.0 + m_dK*m_dGAMMA) => float un;
        // cascade of series filters
        return m_LPF4.doFilter(m_LPF3.doFilter(m_LPF2.doFilter(m_LPF1.doFilter(un))));
    }
}