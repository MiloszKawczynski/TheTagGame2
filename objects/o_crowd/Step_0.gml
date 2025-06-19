for(var i = 0; i < 100; i++)
{
    dotLight[i] -= 0.1 / 5;
    dotPositionX[i] += sin(current_time / 100 + i * pi / 10) * 0.0001;
    dotPositionY[i] += cos(current_time / 100 + i * pi / 10) * 0.0001;
    
    if (dotLight[i] <= 0)
    {
        array_set(dotPositionX, i, random_range(0.2, 0.8));
        array_set(dotPositionY, i, random_range(0.75, 1));
    
        array_set(dotSize, i, random_range(0.005, 0.01));
        array_set(dotLight, i, random_range(1, 3));
    }
}