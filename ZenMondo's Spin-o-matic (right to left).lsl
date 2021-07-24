//Speed Higher Numbers are Slower and Smoother always end with .0
float speed = 100.0;

//Pause Time In Seconds.
float pause = 5.0;

rotToNintey()
{
  rotation desired_rotation =  llGetRot() * llEuler2Rot(< 0, 0, -90 * DEG_TO_RAD>);
   
    rotation starting_rotation = llGetRot();
    //vector starting_rotation = llRot2Euler(llGetRot()) * RAD_TO_DEG;
   
   vector vec_desired_rotation = llRot2Euler(desired_rotation) * DEG_TO_RAD;
   
   vector vec_starting_rotation = llRot2Euler(starting_rotation) * DEG_TO_RAD; 
   
    vector  step  = (vec_desired_rotation - vec_starting_rotation) / speed;
            
    rotation rotstep = llEuler2Rot(step * RAD_TO_DEG);

    integer i;
    for(i = 0 ; i < speed ; i++)
    {
        llSetRot(llGetRot() * rotstep);
    }
   
}


default
{
    state_entry()
    {
        while(TRUE)
        {
            rotToNintey();
            llSleep(pause);
        }
    }

    
}
