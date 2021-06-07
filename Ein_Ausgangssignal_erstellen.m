function  [Eingangssignal Ausgangssignal] = Ein_Ausgangssignal_erstellen (abtastzeit_0_001,abtastzeit_0_029,abtastzeit_0_0029,Noise,Eingangssignal_Rauschen,Ausgangssignal_Rauschen,Ein_und_Ausgangssignal_Rauschen,N10_db,N20_db,N40_db,Begrenzung)

if(Noise==1) %%mit Rauschen 
    if(Eingangssignal_Rauschen==1)
        if(abtastzeit_0_029==1)
            if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_029_Begrenzung_9V\Eingangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_029_Begrenzung_9V\Eingangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_029_Begrenzung_9V\Eingangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_029_Max_5V\Eingangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_029_Max_5V\Eingangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_029_Max_5V\Eingangssignal','noise_40db');
                    load(file) 
                end
            end
        elseif(abtastzeit_0_0029==1)
             if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_0029_Begrenzung_9V\Eingangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_0029_Begrenzung_9V\Eingangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_0029_Begrenzung_9V\Eingangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_0029_Max_5V\Eingangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_0029_Max_5V\Eingangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_0029_Max_5V\Eingangssignal','noise_40db');
                    load(file) 
                end
            end
        elseif(abtastzeit_0_001==1)
             if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_001_Begrenzung_9V\Eingangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_001_Begrenzung_9V\Eingangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_001_Begrenzung_9V\Eingangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_001_Max_5V\Eingangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_001_Max_5V\Eingangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_001_Max_5V\Eingangssignal','noise_40db');
                    load(file) 
                end
            end
         end
    elseif(Ausgangssignal_Rauschen==1)
        if(abtastzeit_0_029==1)
            if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_029_Begrenzung_9V\Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_029_Begrenzung_9V\Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_029_Begrenzung_9V\Ausgangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_029_Max_5V\Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_029_Max_5V\Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_029_Max_5V\Ausgangssignal','noise_40db');
                    load(file) 
                end
            end
        elseif(abtastzeit_0_0029==1)
             if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_0029_Begrenzung_9V\Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_0029_Begrenzung_9V\Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_0029_Begrenzung_9V\Ausgangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_0029_Max_5V\Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_0029_Max_5V\Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_0029_Max_5V\Ausgangssignal','noise_40db');
                    load(file) 
                end
            end
        elseif(abtastzeit_0_001==1)
             if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_001_Begrenzung_9V\Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_001_Begrenzung_9V\Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_001_Begrenzung_9V\Ausgangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_001_Max_5V\Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_001_Max_5V\Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_001_Max_5V\Ausgangssignal','noise_40db');
                    load(file) 
                end
            end
         end
    elseif(Ein_und_Ausgangssignal_Rauschen==1)
        if(abtastzeit_0_029==1)
            if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_029_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_029_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_029_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_029_Max_5V\Eingangssignal_und_Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_029_Max_5V\Eingangssignal_und_Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_029_Max_5V\Eingangssignal_und_Ausgangssignal','noise_40db');
                    load(file) 
                end
            end
        elseif(abtastzeit_0_0029==1)
             if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_0029_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_0029_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_0029_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_0029_Max_5V\Eingangssignal_und_Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_0029_Max_5V\Eingangssignal_und_Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_0029_Max_5V\Eingangssignal_und_Ausgangssignal','noise_40db');
                    load(file) 
                end
            end
        elseif(abtastzeit_0_001==1)
             if(Begrenzung==1)
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_001_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_001_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_001_Begrenzung_9V\Eingangssignal_und_Ausgangssignal','noise_40db');
                    load(file) 
                end
            else
                if(N10_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\10db_Rauschen\0_001_Max_5V\Eingangssignal_und_Ausgangssignal','noise_10db');
                    load(file) 
                elseif(N20_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\20db_Rauschen\0_001_Max_5V\Eingangssignal_und_Ausgangssignal','noise_20db');
                    load(file) 
                elseif(N40_db==1)
                    file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Verrauschte_Signale\40db_Rauschen\0_001_Max_5V\Eingangssignal_und_Ausgangssignal','noise_40db');
                    load(file) 
                end
            end
         end
    end
Eingangssignal = noise(:,1);
Ausgangssignal = noise(:,2);

else %%ohne Rauschen Orginal Signale
    %% Eingangs-Ausgangssignal Laden und richtig zuschneiden!!
    if(abtastzeit_0_029==1)
        if(Begrenzung==1)
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_029_Begrenzung_9V','Eingangssignal_abtastzeit0_029_sättigung');
        load(file) 
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_029_Begrenzung_9V','Ausgangssignal_abtastzeit0_029_sättigung');
        load(file) 
        else
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_029_Max_5V','Eingangssignal_abtastzeit0_029_maximal_5_V');
        load(file) 
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_029_Max_5V','Ausgangssignal_abtastzeit0_029_maximal_5_V');
        load(file)
        end
    elseif(abtastzeit_0_0029==1)
        if(Begrenzung==1)
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_0029_Begrenzung_9V','Eingangssignal_abtastzeit0_0029_sättigung');
        load(file) 
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_0029_Begrenzung_9V','Ausgangssignal_abtastzeit0_0029_sättigung');
        load(file) 
        else
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_0029_Max_5V','Eingangssignal_abtastzeit0_0029_maximal_5_V');
        load(file) 
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_0029_Max_5V','Ausgangssignal_abtastzeit0_0029_maximal_5_V');
        load(file)
        end
    elseif(abtastzeit_0_001==1)
        if(Begrenzung==1)
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_001_Begrenzung_9V','Eingangssignal_abtastzeit0_001_sättigung');
        load(file) 
        file =fullfile('C:\Users\User\Desktop\Master Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_001_Begrenzung_9V','Ausgangssignal_abtastzeit0_001_sättigung');
        load(file) 
        else
        file =fullfile('C:\Users\User\Desktop\Master_Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_001_Max_5V','Eingangssignal_abtastzeit0_001_maximal_5_V');
        load(file) 
        file =fullfile('C:\Users\User\Desktop\Master_Studium\Semester_2\Projektarbeit\Signale\Orginale_Signale\0_001_Max_5V','Ausgangssignal_abtastzeit0_001_maximal_5_V');
        load(file)
        end 
    end
    Eingangssignal = Eingangssignal(:,2);
    Ausgangssignal = Ausgangssignal(:,2);     
end
