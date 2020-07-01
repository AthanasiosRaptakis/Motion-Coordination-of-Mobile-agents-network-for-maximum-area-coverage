%######################################################
%#       Arxikopoihsh metablitwn, statherwn, klp     ##    
%######################################################

function [Xb,Yb,Xr,Yr,R,dx] = conf()
    warning off
    close all
    clear all;
    clc;

    %Xwros drasis
    Xb=[0,2.125,2.9325,2.975,2.9325,2.295,0.85,0.17];
    Yb=[0,0,1.5,1.6,1.7,2.1,2.3,1.2];

    %Arxikes theseis robot
    Xr=[.25,.5,.75,1];
    Yr=[.25,.5,.75,1];

    %Times aktinas
    R=[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];

    %Bima kinisis twn robot
    dx=0.05;
    
end