open Format

let output_rom ?(x0=(-157)) ?(y0=197) ?(z0=(-1309)) rom name =
	if Array.length rom = 0 then
		failwith "The ROM can't be of size 0.";

	let oc = ref (open_out (sprintf "1_%s.rom" name)) in

	for j = 0 to Array.length rom.(0) - 1 do
		if j mod 2 = 0 then
			oc := open_out (sprintf "%d_%s.rom" (j / 2 + 1) name);

		let fmt = formatter_of_out_channel !oc in

		if j mod 2 = 0 then
			fprintf fmt "summon falling_block ~ ~1 ~ {Time:1,BlockState:{Name:air},Passengers:[@.{id:falling_block,Time:1,Passengers:[@.{id:command_block_minecart,Command:'gamerule commandBlockOutput false'},@.";

		for i = 0 to Array.length rom - 1 do
			let block = if rom.(i).(j) = '1' then "redstone_wall_torch[facing=west]" else "air" in
			let x = x0 + 2 * (i mod 16) in
			let y = y0 + 4 * (i / 16) in
			let z = z0 - 2 * j in
			fprintf fmt "{id:command_block_minecart,Command:'setblock %d %d %d minecraft:%s'},@." x y z block
		done;

		if j mod 2 <> 0 then begin
			fprintf fmt "{id:command_block_minecart,Command:'say Loading rom %s %d/%d.'},@." name (j / 2 + 1) 8; (* /!\ 8 hardcodé... *)
			fprintf fmt "{id:command_block_minecart,Command:'summon falling_block ~ ~1 ~ {Time:1,Passengers:[{id:command_block_minecart,Command:\"killall minecarts sysnum\"}]}'}@.]}]}@.";
			close_out !oc;
		end;
	done;
	close_out !oc

(* Test. *)
let binary n k =
	if (n / (1 lsl k)) mod 2 = 0 then '0'
	else '1'

let create_rom f nb_word word_size =
	Array.init nb_word (fun i -> Array.init word_size (f i))

let empty_rom =
	create_rom (fun _ -> (fun _ -> '0'))

let full_rom =
	create_rom (fun _ -> (fun _ -> '1'))

let binary_rom =
	create_rom (fun i -> (fun j -> binary i j))

let count_rom =
	create_rom (fun i -> (fun j -> if i mod 16 = j then '1' else '0'))

let () =
	output_rom (empty_rom 128 16) "empty";
	output_rom (full_rom 128 16) "full";
	output_rom (binary_rom 128 16) "binary";
	output_rom (count_rom 128 16) "count"

