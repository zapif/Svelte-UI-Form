// store.js
import { writable } from "svelte/store";

export const form = writable({
  text: "",
  number: 0,
  checked: false,
});
