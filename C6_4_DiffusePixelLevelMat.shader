// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "Unity Learn/C6_4/Diffuse PixelLevel"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Diffuse;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 worldNormal:TEXCOORD0;//�޸Ĳ���
            };

            v2f vert(a2v v)
            {
                v2f o;
                //�Ѷ�������ת�����ü��ռ�
                o.pos=UnityObjectToClipPos(v.vertex);
                //����ռ��µķ��ߴ��ݸ�ƬԪ
                o.worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                //��û���������
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                //���������������ֵ
                fixed3 worldNormal = normalize(i.worldNormal);
                //��ù��߷���
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                //��������ģ����������� Cdiffuse=(Clight*Mdiffuse)max(0,n*l)
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLightDir));
                //�����������������
                fixed3 color=ambient+diffuse;

                return fixed4(color, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}