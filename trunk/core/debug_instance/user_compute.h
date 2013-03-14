#ifdef LAMBDA_TEST_SHORTEST_PATH
__device__ void Compute(MessageIterator* msgs) {
  //// TODO(laigd): Add user defined Compute function code.
  unsigned int mindist = (get_id() == get_source() ? 0 : dkMaxUInt);
  unsigned int pre = dkMaxUInt;

  for (; !msgs->Done(); msgs->Next()) {
    if (msgs->get_dist() < mindist) {
      mindist = msgs->get_dist();
      pre = msgs->get_from();
    }
  }

  if (mindist < get_dist()) {
    set_dist(mindist);
    set_pre(pre);
    for (OutEdgeIterator it = GetOutEdgeIterator(); !it.Done(); it.Next()) {
      Message msg(*it);
      msg.set_dist(mindist + it->get_weight());
      msg.Send();
    }
  }
}
#endif
