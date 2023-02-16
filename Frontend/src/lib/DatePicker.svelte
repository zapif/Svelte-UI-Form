<script context="module">
  export function iso(date) {
    const pad = (n) => (n < 10 ? "0" + n : n);
    return (
      date.getFullYear() +
      "-" +
      pad(date.getMonth() + 1) +
      "-" +
      pad(date.getDate())
    );
  }
</script>

<script>
  export let date = iso(new Date());
  export let days = "Su|Mo|Tu|We|Th|Fr|Sa".split("|");
  export let months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  export let start = 0; // first day of the week (0 = Sunday, 1 = Monday)
  export let offset = 0; // offset in months from currently selected date
  export let type = 1;
  export let value;
  let first = new Date("01 " + "January 2003").getFullYear();
  let second = new Date().getFullYear();
  let startDate = new Date();
  let years = Array();
  for (let i = first; i <= second; i++) years.push(i);
  let monthSelected = months[startDate.getMonth()];
  let yearSelected = startDate.getFullYear();
  let prevMonthIndex = months.indexOf(monthSelected);
  let prevYear = yearSelected;
  $: value = date;
  function go(direction) {
    if (monthSelected == "January" && direction < 0) {
      if (yearSelected != years[0]) {
        monthSelected = months[11];
        yearSelected = yearSelected - 1;
        offset = offset + direction;
      }
    } else if (monthSelected == "December" && direction > 0) {
      if (yearSelected != startDate.getFullYear()) {
        monthSelected = months[0];
        yearSelected = yearSelected + 1;
        offset = offset + direction;
      }
    } else {
      monthSelected = months[months.indexOf(monthSelected) + direction];
      offset = offset + direction;
    }
    console.log(monthSelected);
  }

  function goMonth() {
    let monthIndex = months.indexOf(monthSelected);
    offset = offset + (monthIndex - prevMonthIndex);
    prevMonthIndex = monthIndex;
  }

  function goYear() {
    offset = offset + (yearSelected - prevYear) * 12;
    prevYear = yearSelected;
  }

  function selectDate(newValue) {
    let newDate = new Date(newValue);
    // const month = months[newDate.getMonth()];
    // const year = newDate.getFullYear();
    // if (months.indexOf(month) < months.indexOf(monthSelected)) {
    //   offset = offset - 1;
    // } else if (months.indexOf(month) > months.indexOf(monthSelected)) {
    //   offset = offset + 1;
    // } else {
    //   offset = 0;
    // }
    yearSelected = newDate.getFullYear();
    monthSelected = months[newDate.getMonth()];
    date = newValue;
  }

  $: range = getRange(date, type);

  function getFirstDayOfWeek(d) {
    // 👇️ clone date object, so we don't mutate it
    const date = new Date(d);
    const day = date.getDay(); // 👉️ get day of week

    // 👇️ day of month - day of week (-6 if Sunday), otherwise +1
    const diff = date.getDate() - day + (day === 0 ? -6 : 1);

    return new Date(date.setDate(diff));
  }

  function getRange(date, type) {
    let start = getFirstDayOfWeek(new Date(date + " "));
    let end = new Date(start);
    switch (type) {
      case 1:
        return [date];
      case 3:
        end.setDate(end.getDate() + 6);
        return getDatesArray(start, end);
      case 2:
        end = new Date(date + " ");
        return getDatesArray(start, end);
      default:
        console.log("Incorrect type");
    }
  }

  function getDatesArray(start, end) {
    for (
      var arr = [], dt = new Date(start);
      dt <= new Date(end);
      dt.setDate(dt.getDate() + 1)
    ) {
      arr.push(iso(new Date(dt)));
    }
    return arr;
  }

  function reset() {
    startDate = new Date();
    offset = 0;
    date = iso(startDate);
    monthSelected = months[startDate.getMonth()];
    yearSelected = startDate.getFullYear();
    prevMonthIndex = months.indexOf(monthSelected);
    prevYear = yearSelected;
  }

  // $: monthIndex = months.indexOf(monthSelected);

  $: viewDate = viewDateFrom(date, offset);

  $: month = months[viewDate.getMonth()];

  $: year = viewDate.getFullYear();

  $: weeks = weeksFrom(viewDate, date, start, range);

  function viewDateFrom(date, offset) {
    var viewDate = new Date(date);
    viewDate.setMonth(viewDate.getMonth() + offset);
    return viewDate;
  }

  function weeksFrom(viewDate, date, start, range) {
    range.push(date);
    var first = new Date(viewDate.getTime());
    first.setDate(1);
    first.setDate(first.getDate() + ((start - first.getDay() - 7) % 7));

    var last = new Date(viewDate.getTime());
    last.setDate(
      new Date(viewDate.getFullYear(), viewDate.getMonth() + 1, 0).getDate()
    );
    last.setDate(last.getDate() + ((start - last.getDay() + 6) % 7));

    var d = new Date(first.getTime()),
      M = viewDate.getMonth(),
      Y = viewDate.getFullYear(),
      week = [],
      weeks = [week];
    while (d.getTime() <= last.getTime()) {
      if (d.getFullYear() <= startDate.getFullYear()) {
        var dd = d.getDate(),
          mm = d.getMonth(),
          yy = d.getFullYear(),
          value = iso(d);
        week.push({
          date: dd,
          value,
          class: [
            range.includes(value) ? "selected" : "",
            mm == M ? "" : (mm > M ? yy >= Y : yy > Y) ? "future" : "past",
          ].join(" "),
        });
      }

      d = new Date(d.getFullYear(), d.getMonth(), d.getDate() + 1);

      if (d.getDay() === start) {
        week = [];
        weeks.push(week);
      }
    }
    return weeks;
  }
</script>

<table>
  <tr>
    <!-- <td><button on:click={() => go(-12)}>&#9194; </button></td> -->
    <td><button type="button" on:click={() => go(-1)}>&#9664; </button></td>
    <td colspan="3">
      <select bind:value={monthSelected} on:change={() => goMonth()}>
        {#each months as month}
          <option value={month}>
            {month}
          </option>
        {/each}
      </select>
    </td>
    <td colspan="2">
      <select bind:value={yearSelected} on:change={() => goYear()}>
        {#each years as year}
          <option value={year}>
            {year}
          </option>
        {/each}
      </select>
    </td>

    <!-- <td colspan="3">{month} {year}</td> -->
    <td><button type="button" on:click={() => go(+1)}>&#9654; </button></td>
    <!-- <td><button on:click={() => go(+12)}>&#9194; </button></td> -->
  </tr>
  <tr>
    {#each days as day}
      <th>{day}</th>
    {/each}
  </tr>
  {#each weeks as week}
    <tr>
      {#each week as day}
        <!-- <td class="btn {day.class}" on:click={() => selectDate(day.value)}
          >{day.date}</td
        > -->
        <td class={day.class}>
          <button
            type="button"
            class={day.class}
            on:click={() => selectDate(day.value)}>{day.date}</button
          ></td
        >
      {/each}
    </tr>
  {/each}
</table>
<button type="button" on:click={() => reset()}>Jump to Today</button>

<style>
  td,
  th {
    width: 28px;
    text-align: center;
    border-radius: 4px;
    line-height: 24px;
    margin: 0;
    padding: 0;
  }
  td.past,
  td.future {
    opacity: 0.5;
  }
  select {
    display: table-cell;
    width: 70%;
  }
  button {
    cursor: pointer;
  }
  button:hover {
    background: gray;
    color: white;
  }
  button.selected {
    color: #ffffff;
    font-weight: bold;
    background-color: #006dcc;
    border-color: #002a80;
  }
</style>
