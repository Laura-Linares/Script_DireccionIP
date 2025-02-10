#!/bin/bash
#------Autor: LauraLinares--------
#------Version: V1----------------

#------Declaracion de Variables---


#------Declaración de Funciones---
function validacion_ip {    
    oct1=$(echo $1 | cut -d"." -f1)
    oct2=$(echo $1 | cut -d"." -f2)
    oct3=$(echo $1 | cut -d"." -f3)
    oct4=$(echo $1 | cut -d"." -f4)
            
            # Comprobamos que todos los octetos introducidos son números reales positivos
    dir_ip=($oct1 $oct2 $oct3 $oct4)
    ip=()
    for i in "${dir_ip[@]}"; do
        if ! [[ $i =~ ^[0-9]+$ ]]; then
            echo "El valor $i introducido no es un número real positivo"
        fi
    done

            # Comprobamos que es una dirección válida
    for i in "${dir_ip[@]}"; do
        encontrado=0
        if ! [ $i -ge 0 ]; then
            echo "La dirección $1 no es válida"
            break
        else
            if ! [ $i -le 255 ]; then
                echo "La dirección $1 no es válida"
                break
            else
                encontrado=1
            fi
        fi
        # Declaro una nueva ip con los valores validados
        if [ $encontrado -eq 1 ]; then
            ip+=($i)
        fi
    done

    # Si el array creado con el FOR tiene cuatro valores (los cuatro octetos), entonces es válida
    if [ ${#ip[@]} -eq 4 ]; then

        # Se comprueba que es una ip privada tipo A mirando que el primer octeto sea igual a 10 y luego los otros tres
        # con un for miro que sean mayor o igual a 0
        ippri=($oct2 $oct3 $oct4)
        if [ $oct1 -eq 10 ]; then
            encontrado=0
            for i in ${ippri[@]}; do
                if [ $i -ge 0 ]; then
                encontrado=1
                fi
                if [ $encontrado -eq 1 ]; then
                    ippri+=($i)
                fi
            done
        
        # Compruebo que es una ip privada de tipo B mirando el primer octeto, luego el segundo y luego los otros dos
        elif [ $oct1 -eq 172 ]; then
            ippri2=($oct3 $oct4)
            if [ $oct2 -ge 16 ]; then
                if [ $oct2 -le 31 ]; then
                    for i in ${ippri2[@]}; do
                            if [ $i -ge 0 ]; then
                        encontrado=1
                        fi
                        if [ $encontrado -eq 1 ]; then
                            ippri2+=($i)
                        fi
                    done
                fi
            fi
        
        # Compruebo que es una ip privada de tipo C mirando los dos octetos y luego los otros dos
        elif [ $oct1 -eq 192 ]; then
            ippri3=($oct3 $oct4)
            if [ $oct2 -eq 168 ]; then
                encontrado=0
                for i in ${ippri3[@]}; do
                    if [ $i -ge 0 ]; then
                    encontrado=1
                    fi
                    if [ $encontrado -eq 1 ]; then
                        ippri3+=($i)
                    fi
                done
            fi
        
        # Compruebo si es la usada para broadcast
        elif [ $oct1 -eq 255 ]; then
            ipbroad=($oct2 $oct3 $oct4)
            for i in "${ipbroad[@]}"; do
                encontrado=0
                if [ $i -eq 255 ]; then
                    encontrado=1
                fi
                if [ $encontrado -eq 1 ]; then
                    ipbroad+=($i)
                fi
            done

        # Compruebo si es la usada para todas las direcciones
        elif [ $oct1 -eq 0 ]; then
            ipall=($oct2 $oct3 $oct4)
            for i in "${ipall[@]}"; do
                encontrado=0
                if [ $i -eq 0 ]; then
                    encontrado=1
                fi
                if [ $encontrado -eq 1 ]; then
                    ipall+=($i)
                fi
            done
        fi
    fi

    # Según los resultados de los arrays (contándolos sumándole los datos encontrados) serán de un tipo u otro, pero ya dentro
    # de las válidas
    if [ ${#ippri[@]} -eq 6 ]; then
        echo "La dirección IP $1 es válida y es privada TIPO A"
    elif [ ${#ippri2[@]} -eq 4 ]; then
        echo "La dirección IP $1 es válida y es privada TIPO B"
    elif [ ${#ippri3[@]} -eq 4 ]; then
        echo "La dirección IP $1 es válida y es privada TIPO C"
    elif [ ${#ipbroad[@]} -eq 6 ]; then
        echo "La dirección IP $1 es válida, pero es una dirección reservada, es una dirección de broadcast"
    elif [ ${#ipall[@]} -eq 6 ]; then
        echo "La dirección IP $1 es válida, pero es una dirección reservada, es la dirección usada para red predeterminada"
    else
        echo "La dirección IP $1 es válida y es pública"
    fi 
}


# Realizar un script al que se le pase una dirección IP e informe de si es una dirección válida o no

validacion_ip 255.255.255.255