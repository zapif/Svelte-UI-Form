<script lang="ts">
  import { Checkbox, NumberInput, TextInput } from "@svelteuidev/core";
  import DatePicker from "./lib/DatePicker.svelte";
  let json = {};
  let number = 0;
  let check = false;
  let text = "";
  let startDate = new Date().toISOString().split("T")[0];
  async function submit(e) {
    e.preventDefault();
    console.log("submitted");
    // const formData = new FormData(e.target);
    // formData.append("checked", String(check));
    // formData.append("date", startDate);
    // json = Object.fromEntries(formData.entries());
    json = {
      date: startDate,
      text: text,
      number: number,
      checked: check,
    };
    number = 0;
    text = "";
    check = false;
    startDate = new Date().toISOString().split("T")[0];
    try {
      const options = {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(json),
      };
      const conn = await fetch("/api/create/", options);
      const resp = await conn.json();
      console.log(resp);
      if (resp.status === 200) {
        console.log("success");
      }
    } catch (err) {
      console.log(err);
    }
  }
</script>

<form on:submit={submit}>
  <DatePicker bind:value={startDate} />
  <TextInput name="text" label="Text Input" bind:value={text} />
  <NumberInput
    name="number"
    hideControls
    label="Number Input"
    bind:value={number}
  />
  <Checkbox size="xl" label="Checkbox" bind:checked={check} />
  <button type="submit">Submit</button>
</form>

<pre>
	{JSON.stringify(json, null, 2)}
</pre>
