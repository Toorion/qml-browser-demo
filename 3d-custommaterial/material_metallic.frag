void MAIN()
{
    METALNESS = 1.0;
    ROUGHNESS = 0.1;
    FRESNEL_POWER = 5.0;
}

void AMBIENT_LIGHT()
{
    DIFFUSE += TOTAL_AMBIENT_COLOR;
}
