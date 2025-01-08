// Feather disable all

//This script contains the default profiles, and hence the default bindings and verbs, for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The struct return by this script contains the names of each default profile.
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

function __input_config_verbs()
{
    return {

        keyboard_and_mouse:
        {
            upKey:    		[input_binding_key(vk_up),    input_binding_key("W")],
            downKey:  		[input_binding_key(vk_down),  input_binding_key("S")],
            leftKey:  		[input_binding_key(vk_left),  input_binding_key("A")],
            rightKey: 		[input_binding_key(vk_right), input_binding_key("D")],
			jumpKey:  		[input_binding_key(vk_up),    input_binding_key("W")],
			interactionKey: [input_binding_key(vk_space),    input_binding_key(vk_rshift)],
			skillKey: 		[input_binding_key(vk_lshift),    input_binding_key(vk_rcontrol)],
			
			leave: 			[input_binding_key(vk_backspace)],
        },
        
        gamepad:
        {
            upKey:    		[input_binding_gamepad_axis(gp_axislv, true),  input_binding_gamepad_button(gp_padu)],
            downKey:  		[input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
            leftKey:  		[input_binding_gamepad_axis(gp_axislh, true),  input_binding_gamepad_button(gp_padl)],
            rightKey: 		[input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
			jumpKey:  		[input_binding_gamepad_button(gp_face1)],
			interactionKey: [input_binding_gamepad_button(gp_face3)],
			skillKey: 		[input_binding_gamepad_button(gp_shoulderl), input_binding_gamepad_button(gp_shoulderr)],
		
			leave: 			[input_binding_gamepad_button(gp_face2)],
		
			debugPlayKey:	[input_binding_gamepad_button(gp_start)],
        }
    };
}